extends KinematicBody2D

var seen_player: Node2D = null

export(Array) var rotating_points: Array
var target_rotating_point_index := 0
onready var current_base_rotation := rotation
var current_rotate_patrol_seconds := 0.0
var current_patrol_pause := -1.0

export(float) var rotation_time: float

func _on_seen_start(seen_player_: Node2D) -> void:
	seen_player = seen_player_

func _on_seen_end() -> void:
	seen_player = null

func _on_detected(seen_player_: Node2D) -> void:
	seen_player_.die_from_gunshot()

func _process(delta: float) -> void:
	if seen_player != null:
		rotate_towards(seen_player, delta)
	else:
		patrol(delta)

func rotate_towards(obj: Node2D, delta: float) -> void:
	var current_direction = Vector2.RIGHT.rotated(rotation)
	var target_direction = (obj.global_position - global_position).normalized().rotated(PI / 2)
	rotation = (current_direction.slerp(target_direction, Global.ENEMY_ROTATION_SPEED * delta)).angle()

func patrol(delta: float) -> void:
	if !rotating_points.empty():
		rotate_patrol(delta)

func rotate_patrol(delta: float) -> void:
	if current_patrol_pause > 0.0:
		current_patrol_pause -= delta
		return

	var target_rotating_point: float = rotating_points[target_rotating_point_index]
	if is_equal_approx(rotation_degrees, target_rotating_point):
		target_rotating_point_index = (target_rotating_point_index + 1) % rotating_points.size()
		current_base_rotation = rotation
		current_patrol_pause = Global.ENEMY_PATROL_PAUSE
		current_rotate_patrol_seconds = 0.0
		return

	current_rotate_patrol_seconds += delta
	rotation = lerp(current_base_rotation, deg2rad(target_rotating_point), clamp(current_rotate_patrol_seconds / rotation_time, 0, 1))
