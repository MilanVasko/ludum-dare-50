extends Area2D

func arrive(_subject: Node2D) -> void:
	var err := get_tree().change_scene("res://win/win.tscn")
	assert(err == OK)
