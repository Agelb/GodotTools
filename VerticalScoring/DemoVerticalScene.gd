extends Node

@onready var vertical_score = $VerticalScore
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Scene loaded")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Play"):
		vertical_score.play()
	if Input.is_action_just_pressed("Stop"):
		vertical_score.fade_out_layer(1)
	if Input.is_action_just_pressed("Pause"):
		vertical_score.fade_in_layer(1)
		
