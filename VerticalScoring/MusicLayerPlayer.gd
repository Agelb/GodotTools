extends Node

class_name MusicLayerPlayer

## A MusicLayerPlayer is a wrapper around an AudioStreamPlayer that works
## with MusicLayers instead of raw AudioStreams. 

## The music layer, which contains the AudioStream and layer data
@export var music_layer: MusicLayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

## This is the logical "volume at zero" for audio stream in dBfs
const _zero_volume := -80.0

## Used to tween for fade in/out
const _volume_property := "volume_db"

func mute():
	audio_stream_player.volume_db = _zero_volume

func start(pos: float = 0.0):	
	audio_stream_player.play(pos)

func stop():
	audio_stream_player.stop()	

## Reset the volume of the layer to its default state
func reset_volume():
	if music_layer.autoplay:
		audio_stream_player.volume_db = music_layer.target_volume
	else:
		audio_stream_player.volume_db = _zero_volume

func pause():
	audio_stream_player.stream_paused = true

func unpause():
	audio_stream_player.stream_paused = false

## Sets the audio stream position in seconds. This is needed to synchronize the 
## layer's playback positions
func seek(position: float):
	audio_stream_player.seek(position)

func fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(audio_stream_player, _volume_property, music_layer.target_volume, music_layer.fade_in_time)
	
func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(audio_stream_player, _volume_property, -60.0, music_layer.fade_out_time)
	
func get_playback_position() -> float:
	return audio_stream_player.get_playback_position()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player.bus = music_layer.output_bus_name	
	if music_layer.audio_stream == null:
		printerr("No audio stream was set for layer ", music_layer.name)
	else:
		audio_stream_player.stream = music_layer.audio_stream
	audio_stream_player.volume_db = _zero_volume
