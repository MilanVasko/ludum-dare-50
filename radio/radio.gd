extends CollisionObject2D

var already_used := false

func _ready() -> void:
	$HelpLabel.visible = false

func can_use() -> bool:
	return !already_used

func describe() -> String:
	return "call for help"

func use(player: Node2D) -> void:
	assert(!already_used)
	already_used = true
	$AudioStreamPlayer2D.stop()
	spawn_exit(player)
	show_text()
	$Wave.visible = false

func spawn_exit(player: Node2D) -> void:
	var potential_spawn_points := get_tree().get_nodes_in_group("exit_spawn_point")
	assert(!potential_spawn_points.empty())
	var spawn_point: Node2D = potential_spawn_points[randi() % potential_spawn_points.size()]
	var exit_scene: PackedScene = load("res://exit/exit.tscn")
	var exit := exit_scene.instance()
	spawn_point.add_child(exit)
	get_tree().call_group("exit_spawn_subscriber", "_on_exit_spawned", exit, player)

func show_text() -> void:
	var help_label := $HelpLabel
	help_label.visible = true
	help_label.global_rotation = 0
	yield(get_tree().create_timer(Global.RADIO_TEXT_DISPLAY_TIME), "timeout")
	help_label.visible = false

