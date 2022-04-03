extends KinematicBody2D

# set from VisionCone
var seen_player: Node2D = null
var detection_progress := 0.0

func _ready() -> void:
	get_tree().call_group("enemy_detection_progress_subscriber", "_on_detection_progress_changed", detection_progress)

func _process(delta: float) -> void:
	if seen_player != null:
		detection_progress += Global.ENEMY_DETECTION_PROGRESS_PER_SECOND * delta
		get_tree().call_group("enemy_detection_progress_subscriber", "_on_detection_progress_changed", detection_progress)
		if detection_progress >= 1.0:
			seen_player.die()
		rotate_towards(seen_player, delta)
	else:
		detection_progress = clamp(detection_progress - Global.ENEMY_DETECTION_COOLDOWN_PER_SECOND * delta, 0, 1)
		get_tree().call_group("enemy_detection_progress_subscriber", "_on_detection_progress_changed", detection_progress)

func rotate_towards(obj: Node2D, delta: float) -> void:
	var current_direction = Vector2.RIGHT.rotated(rotation)
	var target_direction = (obj.global_position - global_position).normalized().rotated(PI / 2)
	rotation = (current_direction.slerp(target_direction, Global.ENEMY_ROTATION_SPEED * delta)).angle()
