extends Control

func _on_play_pressed() -> void:
	var err := get_tree().change_scene("res://ingame/ingame.tscn")
	assert(err == OK)
