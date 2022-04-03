extends KinematicBody2D

onready var sprite := $Sprite

var is_running := false
var stamina_depleted := false

var health := 1.0
var stamina := 1.0
var coldness := 0.0
var hunger := 0.0

var health_decay_accum := 0.0
var hunger_fill_per_second := Global.HUNGER_FILL_PER_SECOND
var coldness_fill_per_second := Global.COLDNESS_FILL_PER_SECOND

func _ready():
	get_tree().call_group("health_subscriber", "_on_health_changed", health)
	get_tree().call_group("stamina_subscriber", "_on_stamina_changed", stamina)
	get_tree().call_group("hunger_subscriber", "_on_hunger_changed", hunger)
	get_tree().call_group("coldness_subscriber", "_on_coldness_changed", coldness)

func _process(delta: float) -> void:
	update_health(delta)
	update_stamina(delta)
	update_hunger(delta)
	update_coldness(delta)

func _on_warm_area_arrive(warmth_per_second: float) -> void:
	coldness_fill_per_second -= warmth_per_second

func _on_warm_area_leave(warmth_per_second: float) -> void:
	coldness_fill_per_second += warmth_per_second

func _on_dangerous_area_arrive(damage_per_second: float) -> void:
	health_decay_accum += damage_per_second

func _on_dangerous_area_leave(damage_per_second: float) -> void:
	health_decay_accum -= damage_per_second

func _on_food_eaten(one_time_hunger_relief: float) -> void:
	hunger -= one_time_hunger_relief

func update_health(delta: float) -> void:
	var health_decay := health_decay_accum * delta

	if coldness >= 1.0:
		health_decay += Global.COLDNESS_HEALTH_DECAY_PER_SECOND * delta
	if hunger >= 1.0:
		health_decay += Global.HUNGER_HEALTH_DECAY_PER_SECOND * delta
	if coldness <= 0.2 && hunger <= 0.2:
		health_decay -= Global.GOOD_STATE_HEALTH_BONUS_PER_SECOND * delta

	if health_decay != 0.0:
		health = clamp(health - health_decay, 0, 1)
		get_tree().call_group("health_subscriber", "_on_health_changed", health)
		if health <= 0.0:
			die()

func update_stamina(delta: float) -> void:
	if is_running:
		stamina = max(stamina - Global.STAMINA_DECAY_PER_SECOND * delta, 0.0)
	else:
		stamina += Global.STAMINA_REPLENISH_PER_SECOND * delta
		if stamina >= Global.STAMINA_USABLE_AGAIN_THRESHOLD:
			stamina_depleted = false
		if stamina >= 1.0:
			stamina = 1.0
	get_tree().call_group("stamina_subscriber", "_on_stamina_changed", stamina)

func die():
	var err := get_tree().change_scene("res://death/death.tscn")
	assert(err == OK)

func die_from_gunshot() -> void:
	var err := get_tree().change_scene("res://gunshot_death/gunshot_death.tscn")
	assert(err == OK)

func update_hunger(delta: float) -> void:
	hunger = min(hunger + hunger_fill_per_second * delta, 1)
	get_tree().call_group("hunger_subscriber", "_on_hunger_changed", hunger)

func update_coldness(delta: float) -> void:
	coldness = clamp(coldness + (coldness_fill_per_second * delta), 0, 1)
	get_tree().call_group("coldness_subscriber", "_on_coldness_changed", coldness)

func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	var wants_to_run := Input.is_action_pressed("run")
	var speed: float
	if wants_to_run:
		if !stamina_depleted && stamina > 0.0:
			speed = Global.RUNNING_SPEED
			sprite.speed_scale = Global.RUNNING_SPEED / Global.WALKING_SPEED
			is_running = true
		else:
			stamina_depleted = true
			speed = Global.WALKING_SPEED
			sprite.speed_scale = 1.0
			is_running = false
	else:
		speed = Global.WALKING_SPEED
		sprite.speed_scale = 1.0
		is_running = false

	var _ignored = move_and_slide(direction * speed)
	if direction != Vector2.ZERO:
		sprite.playing = true
		var new_rotation = rotation_towards(direction)
		rotation = lerp_angle(rotation, new_rotation, delta * 20)
	else:
		sprite.frame = 0
		sprite.playing = false

func rotation_towards(direction: Vector2) -> float:
	return -direction.angle_to(Vector2.UP)
