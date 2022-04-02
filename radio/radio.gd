extends CollisionObject2D

var already_used := false

func can_use() -> bool:
	return !already_used

func use():
	assert(!already_used)
	already_used = true
	spawn_exit()

func spawn_exit():
	var potential_spawn_points := get_tree().get_nodes_in_group("exit_spawn_point")
	assert(!potential_spawn_points.empty())
	var spawn_point: Node2D = potential_spawn_points[randi() % potential_spawn_points.size()]
	var exit_scene: PackedScene = load("res://exit/exit.tscn")
	var exit := exit_scene.instance()
	spawn_point.add_child(exit)
