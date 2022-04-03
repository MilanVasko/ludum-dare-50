extends Sprite

var max_size := 0.4
var min_size := 0.0

var duration := 1.8
var cooldown := 0.0

var current_duration := 0.0
var current_cooldown := 0.0

func _process(delta: float) -> void:
	if current_cooldown >= 0.0:
		current_cooldown -= delta
		return

	current_duration += delta
	if current_duration >= duration:
		current_duration = 0.0
		current_cooldown = cooldown
		return

	scale = Vector2.ONE * lerp(min_size, max_size, current_duration / duration)
	
	modulate.a = lerp(1.0, 0.0, current_duration / duration)
