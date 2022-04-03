extends CanvasLayer

onready var controls := $Control/TextureRect/Control

func _ready() -> void:
	controls.visible = false
	yield(get_tree().create_timer(0.5), "timeout")
	controls.visible = true

func _on_try_again_pressed():
	var err := get_tree().change_scene("res://ingame/ingame.tscn")
	assert(err == OK)

func _on_main_menu_pressed():
	var err := get_tree().change_scene("res://main_menu/main_menu.tscn")
	assert(err == OK)
