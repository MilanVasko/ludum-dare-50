extends Panel

func _ready() -> void:
	$VBoxContainer/HBoxContainer/Play.grab_focus()

func _on_main_menu_pressed() -> void:
	var err := get_tree().change_scene("res://main_menu/main_menu.tscn")
	assert(err == OK)

func _on_play_pressed() -> void:
	var err := get_tree().change_scene("res://ingame/ingame.tscn")
	assert(err == OK)
