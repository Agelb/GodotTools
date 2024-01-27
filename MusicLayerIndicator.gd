extends Node2D
class_name MusicLayerIndicator

@onready var color_light: Sprite2D = $Sprite2D
@onready var border: Sprite2D = $Border
@onready var label: RichTextLabel = $RichTextLabel

var layer: MusicLayer

func show_on():
	var tween = get_tree().create_tween()
	tween.tween_property(color_light, "modulate", Color.LIME_GREEN, layer.fade_in_time)

func show_off():
	var tween = get_tree().create_tween()
	tween.tween_property(color_light, "modulate", Color.DARK_RED, layer.fade_out_time)

func show_playing():
	border.modulate = Color.FOREST_GREEN

func show_stopped():
	border.modulate = Color.DIM_GRAY

func show_paused():
	border.modulate = Color.CADET_BLUE

func set_layer_name(layer_name: String):
	label.text = layer_name

func _ready():
	border.modulate = Color.DIM_GRAY
	color_light.modulate = Color.DARK_RED	
