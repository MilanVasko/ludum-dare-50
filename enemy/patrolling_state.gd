extends Node

export(NodePath) var enemy_path: NodePath
onready var enemy: Node2D = get_node(enemy_path)
export(float) var rotation_time: float

var walk_points: Array = []
var rotating_points: Array = []

var target_walk_point_index := 0
var current_walk_patrol_pause := -1.0

var target_rotating_point_index := 0
var current_rotate_patrol_seconds := 0.0
var current_rotate_patrol_pause := -1.0
onready var current_base_rotation := enemy.rotation

func _on_patrolling_path_found(path: Path2D) -> void:
	walk_points = extract_walk_points(path)

func extract_walk_points(path: Path2D) -> Array:
	var curve := path.curve
	var result := []
	for i in range(curve.get_point_count()):
		result.append(path.to_global(curve.get_point_position(i)))
	return result

func _physics_process(delta: float) -> void:
	if !walk_points.empty():
		walk_patrol(delta)
	if !rotating_points.empty():
		rotate_patrol(delta)

func walk_patrol(delta: float) -> void:
	if current_walk_patrol_pause > 0.0:
		current_walk_patrol_pause -= delta
		return

	var target: Vector2 = walk_points[target_walk_point_index]
	if enemy.walk_towards(target):
		target_walk_point_index = (target_walk_point_index + 1) % walk_points.size()
		current_walk_patrol_pause = Global.ENEMY_PATROL_PAUSE
	enemy.rotate_towards(target, delta, Global.ENEMY_TURN_SPEED)

func rotate_patrol(delta: float) -> void:
	if current_rotate_patrol_pause > 0.0:
		current_rotate_patrol_pause -= delta
		return

	var target_rotating_point: float = rotating_points[target_rotating_point_index]
	if is_equal_approx(enemy.rotation_degrees, target_rotating_point):
		target_rotating_point_index = (target_rotating_point_index + 1) % rotating_points.size()
		current_base_rotation = enemy.rotation
		current_rotate_patrol_pause = Global.ENEMY_PATROL_PAUSE
		current_rotate_patrol_seconds = 0.0
		return

	current_rotate_patrol_seconds += delta
	enemy.rotation = lerp(current_base_rotation, deg2rad(target_rotating_point), clamp(current_rotate_patrol_seconds / rotation_time, 0, 1))
