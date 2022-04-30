extends KinematicBody2D

signal patrolling_path_found(path)

export(NodePath) var patrolling_path_path: NodePath
export(Array) var rotating_points: Array

var seen_player: Node2D = null

const REACH_DISTANCE = 5.0
const MAX_SPEED = 200.0

onready var current_base_rotation := rotation

var walk_velocity := Vector2.ZERO

func _ready() -> void:
	var patrolling_path := get_node_or_null(patrolling_path_path)
	if patrolling_path != null:
		emit_signal("patrolling_path_found", patrolling_path)
	$PatrollingState.set_process(true)
	$PatrollingState.rotating_points = rotating_points

func _on_seen_start(seen_player_: Node2D) -> void:
	$PatrollingState.set_process(false)
	seen_player = seen_player_

func _on_seen_end() -> void:
	$PatrollingState.set_process(true)
	seen_player = null

func _on_detected(seen_player_: Node2D) -> void:
	seen_player_.die_from_gunshot()

func _physics_process(delta: float) -> void:
	if seen_player != null:
		rotate_towards(seen_player.global_position, delta, Global.ENEMY_ROTATION_SPEED)

func rotate_towards(target_global_position: Vector2, delta: float, turn_speed: float) -> void:
	var target_direction := global_position.direction_to(target_global_position)
	rotate_towards_direction(target_direction, delta, turn_speed)

func rotate_towards_direction(target_direction: Vector2, delta: float, turn_speed: float) -> void:
	var current_direction = Vector2.UP.rotated(global_rotation)
	global_rotation = current_direction.slerp(target_direction, turn_speed * delta)\
		.rotated(PI/2.0)\
		.angle()

func walk_towards(target_global_position: Vector2) -> bool:
	var target_distance_squared := global_position.distance_squared_to(target_global_position)
	if target_distance_squared < REACH_DISTANCE * REACH_DISTANCE:
		return true

	var target_direction := (target_global_position - global_position) / sqrt(target_distance_squared)
	walk_velocity = move_and_slide(target_direction * MAX_SPEED)
	return false
