extends Node

@export var layers = []
@export var autoplay: bool = false

var _layer_players = []
var _layer_scene: PackedScene = preload("res://VerticalScoring/MusicLayerPlayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for layer in layers:
		var l: MusicLayer = layer as MusicLayer
		var layer_player = _layer_scene.instantiate() as MusicLayerPlayer
		layer_player.music_layer = l
		add_child(layer_player)
		layer_player.stop()	
		layer_player.reset_volume()
		_layer_players.append(layer_player)

func fade_in_layer(layer_index: int):
	if layer_index >= layers.size():
		return
	var l: MusicLayerPlayer = _layer_players[layer_index] as MusicLayerPlayer
	l.fade_in()

func fade_out_layer(layer_index: int):
	if layer_index >= layers.size():
		return
	var l: MusicLayerPlayer = _layer_players[layer_index] as MusicLayerPlayer
	l.fade_out()

func play():
	var index = 0
	for layer in _layer_players:
		var l = layer as MusicLayerPlayer
		if index > 0:
			l.start((_layer_players[index-1] as MusicLayerPlayer).get_playback_position())
		else:
			l.start()
		index += 1

func stop():
	for layer in _layer_players:
		var l = layer as MusicLayerPlayer
		l.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
