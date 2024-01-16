extends Resource

class_name MusicLayer


## Initial volume of the layer in dB
@export var target_volume: float = 0.0
@export var autoplay: bool = false
@export var output_bus_name: String = "Master"
@export var audio_stream: AudioStream
## Time in seconds to fade in to the target_volume
@export var fade_in_time: float = 0.5
## Time in seconds to fade out to zero
@export var fade_out_time: float = 0.5
