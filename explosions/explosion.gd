extends Node2D

export(Array) var explosion_sounds: Array

export(float) var min_delay: float
export(float) var max_delay: float

onready var current_delay = rand_range(min_delay, max_delay)
onready var audio_source := $AudioSource

var current_rotation := deg2rad(rand_range(0.0, 360.0))

func _process(delta: float) -> void:
	global_rotation = current_rotation
	current_delay -= delta
	if current_delay < 0.0:
		current_rotation = deg2rad(rand_range(0.0, 360.0))
		play_explosion()
		current_delay = rand_range(min_delay, max_delay)

func play_explosion() -> void:
	audio_source.stream = explosion_sounds[randi() % explosion_sounds.size()]
	audio_source.play()
	get_tree().call_group("explosion_subscriber", "_on_explosion_played")
