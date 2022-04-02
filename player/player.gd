extends KinematicBody2D

const WALKING_SPEED = 200.0
const RUNNING_SPEED = 350.0

func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	var speed = RUNNING_SPEED if Input.is_action_pressed("run") else WALKING_SPEED

	move_and_slide(direction * speed)
	if direction != Vector2.ZERO:
		var new_rotation = rotation_towards(direction)
		rotation = lerp_angle(rotation, new_rotation, 0.5)

func rotation_towards(direction: Vector2) -> float:
	return -direction.angle_to(Vector2.UP)
