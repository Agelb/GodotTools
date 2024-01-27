extends Resource

class_name MusicLayer

## A MusicLayer is a resource that captures all the data needed to use an
## audio stream as part of an interactive, vertical score. 

## The name of the layer can be used for interaction and for debugging
@export var name: String = ""

## Initial volume of the layer in dB
@export var target_volume: float = 0.0

## If true, the layer will automatically be set to its target volume when the
## score is started
@export var autoplay: bool = false

## The target output bus for the layer. If the bus doesn't exit, it will 
## default to master
@export var output_bus_name: String = "Master"

## The audio content of the layer
@export var audio_stream: AudioStream

## Time in seconds to fade in to the target_volume
@export var fade_in_time: float = 0.5

## Time in seconds to fade out to zero
@export var fade_out_time: float = 0.5
