extends Node

class_name Jukebox
## The Jukebox provides a simple place to play music with little to no interaction.
##
## The Jukebox handles playlists of tracks, and allows easy switching between tracks
## while handling crossfading to avoid pops and clicks.

enum JukeboxState {
	PLAYING,
	PAUSED,
	STOPPED
}

## Emits when a song has started. Does not emit when resuming a paused song.
signal song_started

## Emits when a song has finished playing. Does not emit when a song is paused or stopped
signal song_finished

## Emits when the playlist data has been preloaded
signal load_complete
## The current behavior of the jukebox
@export var status: JukeboxState = JukeboxState.STOPPED
## When true, the jukebox will load all music content in the playlist directory
## on ready
@export var autoload: bool = false
## The amount of time to wait when one song ends before playing the next
@export var between_song_pause = 2.0
## Where the jukebox will load audio streams
@export var playlist_directory := "res://Audio/Playlist"

@export var autoplay: bool = true

@onready var audio_player: AudioStreamPlayer = $AudioStream
@onready var next_song_timer: Timer = $NextSongTimer

## Pointer to the audio stream resource loaded in the stream player
var _current_play_index: int = -1

## It's a set, but there are no sets yet, so we pretend its a set
var _allowed_file_extensions := {"ogg": null, "mp3": null, "wav": null}

## Contains the AudioStream resources when the load is complete
var _preloaded_music = []

## When true, the jukebox will finish playing the current song and then stop
var _stop_after_song: bool = false
	
## Manually trigger a load from disk. This can be useful to control when resources are loaded to avoid
## latency or unwanted spikes during gameplay
func load_audio_from_disk():
	_load_from_folder(playlist_directory)	
	
## TODO - add a function to skip to the next song
	
## Begin playback. If nothing is currently playing, the next song will be loaded
## and then played. If paused, the current song is resumed.
func play():
	if status == JukeboxState.PAUSED:
		status = JukeboxState.PLAYING
		audio_player.stream_paused = false
		return
	
	if audio_player.stream == null:
		_load_next_song()
	if audio_player.stream == null:
		printerr("No songs were available in the jukebox. Were songs loaded successfully with autoload or manually loaded?")
		status = JukeboxState.STOPPED
		return
	song_started.emit()
	status = JukeboxState.PLAYING
	audio_player.play()

## Stop playback and reset the current song to the beginning
func stop():
	status = JukeboxState.STOPPED
	audio_player.stop()
	audio_player.stream_paused = false
	
## Pauses the current song. The next call to play will resume from the current playback position
func pause():
	status = JukeboxState.PAUSED
	audio_player.stream_paused = true

## Loads the next song into the audio stream. If the playlist is at the 
## end, it will restart. If nothing is currently loaded, the first song in the playlist
## is loaded
func _load_next_song():	
	if _preloaded_music.size() <= 0:
		return
	_current_play_index += 1
	if _current_play_index >= _preloaded_music.size():
		_current_play_index = 0
	audio_player.stream = _preloaded_music[_current_play_index]	

# Called when the node enters the scene tree for the first time.
func _ready():	
	if (autoload):
		_load_from_folder(playlist_directory)

func _on_audio_stream_finished():
	song_finished.emit()
	if _stop_after_song:
		stop()
	else:
		_load_next_song()
		next_song_timer.start()	

func _load_complete():
	load_complete.emit()
	if (autoplay):
		play()

func _on_next_song_timer_timeout():
	play()
	song_started.emit()
	
## This will iterate through all files in the provided path, and then load any
## wav, ogg, or mp3 files as AudioStreams. The streams will then stay loaded
## and played as a playlist in the jukebox
## TODO - only load one at a time and begin loading the next at a certain point
## TODO - add a function to clear the jukebox to unload any used resources
func _load_from_folder(path: String):
	var dir = DirAccess.open(path)
	if dir == null:
		printerr("Could not open music directory")
		return
	
	_preloaded_music.clear() # TODO - Ensure this isn't a memory leak
	for file in dir.get_files():		
		if _allowed_file_extensions.has(file.get_extension().to_lower()):
			var preloaded_stream = load(path + "/" + file)
			if preloaded_stream != null:
				_preloaded_music.append(preloaded_stream)
	_load_complete()
