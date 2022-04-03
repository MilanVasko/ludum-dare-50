extends Camera2D

var shake_duration := 0.8
var max_offset := Vector2(50.0, 25.0)
export var max_roll := 0.1

var shake := 0.0
var shake_power := 3

onready var noise = OpenSimplexNoise.new()
var noise_y := 0.0

func _ready() -> void:
	noise.seed = randi()
	noise.period = 4.0
	noise.octaves = 2.0

func _on_explosion_played() -> void:
	shake = 1.0

func _process(delta: float) -> void:
	if shake <= 0.0:
		return
	shake = max(shake - shake_duration * delta, 0.0)
	var amount = pow(shake, shake_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
