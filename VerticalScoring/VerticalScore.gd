extends Node
class_name VerticalScore
## A VerticalScore represents a single musical event that is composed of multiple layers.
## Layers can be faded in and out individually while the score is playing, and the
## playback positions will remain synchronized across all layers
##
## A layer is defined by a resource file that contains the audio stream for that layers, as well as
## additional metadata

signal started
signal stopped
signal paused
signal unpaused
signal layer_started(index: int)
signal layer_stopped(index: int)

## The layers available in this score
@export var layers: Array[MusicLayer] = []

## When true, the score will start playing on ready
@export var autoplay: bool = false

var _is_paused: bool = false
var _layer_players: Array[MusicLayerPlayer] = []
var _layer_scene: PackedScene = preload("res://VerticalScoring/MusicLayerPlayer.tscn")
var _layer_toggles = {}
var _is_playing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for layer in layers:
		_layer_players.append(_create_layer_player(layer))
	print("Vertical score: ", _layer_players.size(), " layers available")


func num_layers() -> int:
	return _layer_players.size()

func fade_in_layer(layer_index: int):
	if layer_index >= layers.size():
		return
	_layer_players[layer_index].fade_in()
	layer_started.emit(layer_index)

func fade_out_layer(layer_index: int):
	if layer_index >= layers.size():
		return
	_layer_players[layer_index].fade_out()	
	layer_stopped.emit(layer_index)

func is_playing() -> bool:
	return _is_playing

func play():
	_is_paused = false
	if _layer_players.is_empty():
		return
	
	var source = _layer_players[0]
	source.start()
	layer_started.emit(0)
	
	if _layer_players.size() == 1:
		return
	for i in range(1, _layer_players.size()):
			_layer_players[i].start(source.get_playback_position())
			if layers[i].autoplay:
				fade_in_layer(i)
	
	_is_playing = true
	started.emit()

func stop():
	_is_paused = false
	for layer in _layer_players:
		var l = layer as MusicLayerPlayer
		l.stop()
	_is_playing = false
	stopped.emit()


func _synchronize_layers():
	if _layer_players.size() == 1:
		return
	
	var source = _layer_players[0]
	for i in range(1, _layer_players.size()):
		_layer_players[i].seek(source.get_playback_position())

func toggle_pause():
	if !_is_playing:
		return
		
	if _is_paused:
		_synchronize_layers()
		for l in _layer_players:
			l.unpause()
		_is_paused = false
		unpaused.emit()
	else:
		for l in _layer_players:
			l.pause()
		_is_paused = true
		paused.emit()

func _reset_layer(l: MusicLayerPlayer):
	l.stop()
	l.reset_volume()

func _create_layer_player(l: MusicLayer) -> MusicLayerPlayer:		
	var layer_player = _layer_scene.instantiate() as MusicLayerPlayer
	layer_player.name = "MLP_"+l.name
	layer_player.music_layer = l
	add_child(layer_player)
	_reset_layer(layer_player)
	return layer_player

func _reset_layers():	
	for layer in _layer_players:
		_reset_layer(layer)

func _toggle_layer(i: int):
	if _layer_toggles.has(i):
		_layer_toggles[i] = !_layer_toggles[i]
		if _layer_toggles[i]:
			fade_in_layer(i)
		else:
			fade_out_layer(i)
	else:
		_layer_toggles[i] = true
		fade_in_layer(i)

