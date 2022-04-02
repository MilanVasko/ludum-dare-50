extends KinematicBody2D

const WALKING_SPEED := 200.0
const RUNNING_SPEED := 350.0
const COLDNESS_FILL_PER_SECOND := 0.025
const COLDNESS_HEALTH_DECAY_PER_SECOND := 0.005
const HUNGER_FILL_PER_SECOND := 0.015
const HUNGER_HEALTH_DECAY_PER_SECOND := 0.0025
const FIRE_HEALTH_DECAY_PER_SECOND := 0.2
const STAMINA_REPLENISH_PER_SECOND := 0.1
const STAMINA_DECAY_PER_SECOND := 0.2

var dead := false
var in_fire := false
var is_running := false
var stamina_depleted := false

var health := 1.0
var stamina := 1.0
var coldness := 0.0
var hunger := 0.0

var coldness_fill_per_second := COLDNESS_FILL_PER_SECOND

func _ready():
	get_tree().call_group("health_subscriber", "_on_health_changed", health)
	get_tree().call_group("stamina_subscriber", "_on_stamina_changed", stamina)
	get_tree().call_group("hunger_subscriber", "_on_hunger_changed", hunger)
	get_tree().call_group("coldness_subscriber", "_on_coldness_changed", coldness)

func _process(delta: float) -> void:
	if dead:
		return
	update_health(delta)
	update_stamina(delta)
	update_hunger(delta)
	update_coldness(delta)

func _on_fire_entered() -> void:
	in_fire = true

func _on_fire_exited() -> void:
	in_fire = false

func _on_warm_area_arrive(warmth_per_second: float) -> void:
	coldness_fill_per_second -= warmth_per_second
	print("current coldness " + str(coldness_fill_per_second))

func _on_warm_area_leave(warmth_per_second: float) -> void:
	coldness_fill_per_second += warmth_per_second
	print("current coldness " + str(coldness_fill_per_second))

func update_health(delta: float) -> void:
	var health_decay := 0.0
	if coldness >= 1.0:
		health_decay += COLDNESS_HEALTH_DECAY_PER_SECOND * delta
	if hunger >= 1.0:
		health_decay += HUNGER_HEALTH_DECAY_PER_SECOND * delta
	if in_fire:
		health_decay += FIRE_HEALTH_DECAY_PER_SECOND * delta
	if health_decay > 0.0:
		health -= health_decay
		get_tree().call_group("health_subscriber", "_on_health_changed", health)
		if health <= 0.0:
			die()

func update_stamina(delta: float) -> void:
	if is_running:
		stamina = max(stamina - STAMINA_DECAY_PER_SECOND * delta, 0.0)
	else:
		stamina += STAMINA_REPLENISH_PER_SECOND * delta
		if stamina >= 1.0:
			stamina = 1.0
			stamina_depleted = false
	get_tree().call_group("stamina_subscriber", "_on_stamina_changed", stamina)

func die():
	dead = true
	get_tree().call_group("player_death_subscriber", "_on_player_died")

func update_hunger(delta: float) -> void:
	if hunger < 1.0:
		hunger += HUNGER_FILL_PER_SECOND * delta
		get_tree().call_group("hunger_subscriber", "_on_hunger_changed", hunger)

func update_coldness(delta: float) -> void:
	coldness = clamp(coldness + (coldness_fill_per_second * delta), 0, 1)
	get_tree().call_group("coldness_subscriber", "_on_coldness_changed", coldness)

func _physics_process(delta: float) -> void:
	if dead:
		return

	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	var wants_to_run := Input.is_action_pressed("run")
	var speed: float
	if wants_to_run:
		if !stamina_depleted && stamina > 0.0:
			speed = RUNNING_SPEED
			is_running = true
		else:
			stamina_depleted = true
			speed = WALKING_SPEED
			is_running = false
	else:
		speed = WALKING_SPEED
		is_running = false

	var _ignored = move_and_slide(direction * speed)
	if direction != Vector2.ZERO:
		var new_rotation = rotation_towards(direction)
		rotation = lerp_angle(rotation, new_rotation, delta * 20)

func rotation_towards(direction: Vector2) -> float:
	return -direction.angle_to(Vector2.UP)
