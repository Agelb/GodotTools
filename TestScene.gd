extends Node

@onready var jukebox: Jukebox = $Jukebox
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Play"):
		jukebox.play()
	elif Input.is_action_just_pressed("Pause"):
		jukebox.pause()
	elif Input.is_action_just_pressed("Stop"):
		jukebox.stop()


func _on_jukebox_load_complete():
	print("Jukebox Load complete")


func _on_jukebox_song_finished():
	print("Song finished")


func _on_jukebox_song_started():
	print("Song started")
