extends KinematicBody2D

onready var light := $VisionCone/Light2D

# set from VisionCone
var seen_player: Node2D = null
var detection_progress := 0.0

export(Array) var rotating_points: Array
var target_rotating_point_index := 0
onready var current_base_rotation := rotation
var current_rotate_patrol_seconds := 0.0
var current_patrol_pause := -1.0

export(float) var rotation_time: float

func _ready() -> void:
	light.update_progress(detection_progress)

func _process(delta: float) -> void:
	if seen_player != null:
		detection_progress += Global.ENEMY_DETECTION_PROGRESS_PER_SECOND * delta
		light.update_progress(detection_progress)
		if detection_progress >= 1.0:
			seen_player.die()
		rotate_towards(seen_player, delta)
	else:
		patrol(delta)
		if detection_progress > 0.0:
			detection_progress = max(detection_progress - Global.ENEMY_DETECTION_COOLDOWN_PER_SECOND * delta, 0)
			light.update_progress(detection_progress)

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
