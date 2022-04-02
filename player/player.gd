extends KinematicBody2D

const WALKING_SPEED := 200.0
const RUNNING_SPEED := 350.0
const COLDNESS_FILL_PER_SECOND := 0.05
const COLDNESS_HEALTH_DECAY_PER_SECOND := 0.001
const HUNGER_FILL_PER_SECOND := 0.5
const HUNGER_HEALTH_DECAY_PER_SECOND := 0.001

var health := 1.0
var coldness := 0.0
var hunger := 0.0

func _ready():
	get_tree().call_group("health_subscriber", "_on_health_changed", health)
	get_tree().call_group("hunger_subscriber", "_on_hunger_changed", hunger)
	get_tree().call_group("coldness_subscriber", "_on_coldness_changed", coldness)

func _process(delta: float) -> void:
	update_health(delta)
	update_hunger(delta)
	update_coldness(delta)

func update_health(delta: float) -> void:
	var health_decay := 0.0
	if coldness >= 1.0:
		health_decay += COLDNESS_HEALTH_DECAY_PER_SECOND * delta
	if hunger >= 1.0:
		health_decay += HUNGER_HEALTH_DECAY_PER_SECOND * delta
	if health_decay > 0.0:
		health -= health_decay
		get_tree().call_group("health_subscriber", "_on_health_changed", health)

func update_hunger(delta: float) -> void:
	if hunger < 1.0:
		hunger += HUNGER_FILL_PER_SECOND * delta
		get_tree().call_group("hunger_subscriber", "_on_hunger_changed", hunger)

func update_coldness(delta: float) -> void:
	if coldness < 1.0:
		coldness += COLDNESS_FILL_PER_SECOND * delta
		get_tree().call_group("coldness_subscriber", "_on_coldness_changed", coldness)

func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	var speed = RUNNING_SPEED if Input.is_action_pressed("run") else WALKING_SPEED

	move_and_slide(direction * speed)
	if direction != Vector2.ZERO:
		var new_rotation = rotation_towards(direction)
		rotation = lerp_angle(rotation, new_rotation, delta * 20)

func rotation_towards(direction: Vector2) -> float:
	return -direction.angle_to(Vector2.UP)
