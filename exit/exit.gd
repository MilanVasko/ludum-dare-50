extends Area2D

func arrive(_subject: Node2D) -> void:
	get_tree().call_group("exit_each_subscriber", "_on_exit_reached")
