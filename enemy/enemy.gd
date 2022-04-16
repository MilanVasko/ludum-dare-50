extends KinematicBody2D

var seen_player: Node2D = null

export(Array) var rotating_points: Array
export(Array) var walk_points: Array

export(Curve) var walk_speed_for_distance: Curve
export(float) var variable_speed_distance: float

const REACH_DISTANCE = 5.0
const MAX_SPEED = 200.0

onready var current_base_rotation := rotation

var target_rotating_point_index := 0
var current_rotate_patrol_seconds := 0.0
var current_rotate_patrol_pause := -1.0

var walk_velocity := Vector2.ZERO
var target_walk_point_index := 0
var current_walk_patrol_pause := -1.0

export(float) var rotation_time: float

func _on_seen_start(seen_player_: Node2D) -> void:
	seen_player = seen_player_

func _on_seen_end() -> void:
	seen_player = null

func _on_detected(seen_player_: Node2D) -> void:
	seen_player_.die_from_gunshot()

func _physics_process(delta: float) -> void:
	if seen_player != null:
		rotate_towards(seen_player.global_position, delta, Global.ENEMY_ROTATION_SPEED)
	else:
		patrol(delta)

func rotate_towards(target_global_position: Vector2, delta: float, turn_speed: float) -> void:
	var target_direction := global_position.direction_to(target_global_position)
	rotate_towards_direction(target_direction, delta, turn_speed)

func rotate_towards_direction(target_direction: Vector2, delta: float, turn_speed: float) -> void:
	var current_direction = Vector2.UP.rotated(global_rotation)
	global_rotation = current_direction.slerp(target_direction, turn_speed * delta)\
		.rotated(PI/2.0)\
		.angle()

func patrol(delta: float) -> void:
	if !rotating_points.empty():
		rotate_patrol(delta)
	if !walk_points.empty():
		walk_patrol(delta)

func rotate_patrol(delta: float) -> void:
	if current_rotate_patrol_pause > 0.0:
		current_rotate_patrol_pause -= delta
		return

	var target_rotating_point: float = rotating_points[target_rotating_point_index]
	if is_equal_approx(rotation_degrees, target_rotating_point):
		target_rotating_point_index = (target_rotating_point_index + 1) % rotating_points.size()
		current_base_rotation = rotation
		current_rotate_patrol_pause = Global.ENEMY_PATROL_PAUSE
		current_rotate_patrol_seconds = 0.0
		return

	current_rotate_patrol_seconds += delta
	rotation = lerp(current_base_rotation, deg2rad(target_rotating_point), clamp(current_rotate_patrol_seconds / rotation_time, 0, 1))

func walk_patrol(delta: float) -> void:
	if current_walk_patrol_pause > 0.0:
		current_walk_patrol_pause -= delta
		return

	if walk_towards(walk_points[target_walk_point_index], delta):
		target_walk_point_index = (target_walk_point_index + 1) % walk_points.size()
		current_walk_patrol_pause = Global.ENEMY_PATROL_PAUSE

func walk_towards(target_global_position: Vector2, delta: float) -> bool:
	var target_distance_squared := global_position.distance_squared_to(target_global_position)
	if target_distance_squared < REACH_DISTANCE * REACH_DISTANCE:
		return true

	var target_direction := (target_global_position - global_position) / sqrt(target_distance_squared)
	walk_velocity = move_and_slide(target_direction * MAX_SPEED)
	rotate_towards_direction(target_direction, delta, Global.ENEMY_TURN_SPEED)
	return false
