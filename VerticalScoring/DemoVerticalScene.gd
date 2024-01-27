extends Node

@onready var vertical_score: VerticalScore = $VerticalScore

var indicator: PackedScene = preload("res://music_layer_indicator.tscn")
var _layers: Array[MusicLayerIndicator] = []

const _x_increment = 100
const _y_increment = 100

func _ready():
	var _next_x = 100
	for layer in vertical_score.layers:
		var layer_indicator = indicator.instantiate() as MusicLayerIndicator		
		layer_indicator.name = "ML_"+layer.name
		add_child(layer_indicator)		
		## Really simple layout, and doesn't account for overflowing the screen
		layer_indicator.position.x = _next_x
		layer_indicator.position.y = _y_increment
		layer_indicator.set_layer_name(layer.name)
		layer_indicator.layer = layer
		_layers.append(layer_indicator)
		_next_x += _x_increment	

func _process(_delta):
	if Input.is_action_just_pressed("Play"):
		if vertical_score.is_playing():
			vertical_score.stop()
		else:
			vertical_score.play()
	if Input.is_action_just_pressed("Pause"):
		vertical_score._toggle_layer(1)
	if Input.is_action_just_pressed("Stop"):
		vertical_score._toggle_layer(2)
	if Input.is_action_just_pressed("E"):
		vertical_score.toggle_pause()

func _select_layer(index: int) -> MusicLayerIndicator:
	if index < 0 || index >= _layers.size():
		return null
	return _layers[index]	

func _on_vertical_score_layer_started(index):	
	_select_layer(index).show_on()

func _on_vertical_score_layer_stopped(index):	
	_select_layer(index).show_off()

func _on_vertical_score_started():
	for l in _layers:
		l.show_playing()

func _on_vertical_score_stopped():
	for l in _layers:
		l.show_stopped()


func _on_vertical_score_unpaused():
	for l in _layers:
		l.show_playing()

func _on_vertical_score_paused():
	for l in _layers:
		l.show_paused()
