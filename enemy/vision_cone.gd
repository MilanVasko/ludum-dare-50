extends Area2D

export(NodePath) var enemy_path: NodePath
onready var enemy := get_node(enemy_path)

func arrive(subject: Node2D):
	if subject.is_in_group("player"):
		enemy.seen_player = subject

func leave(subject: Node2D):
	if subject == enemy.seen_player:
		enemy.seen_player = null
