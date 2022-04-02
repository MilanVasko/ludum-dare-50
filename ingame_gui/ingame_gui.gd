extends Control

onready var health_bar := $Stats/Health/ProgressBar
onready var stamina_bar := $Stats/Stamina/ProgressBar
onready var hunger_bar := $Stats/Hunger/ProgressBar
onready var coldness_bar := $Stats/Coldness/ProgressBar
onready var death_screen := $DeathScreen

func _ready():
	death_screen.visible = false

func _on_health_changed(new_health: float) -> void:
	health_bar.value = new_health * health_bar.max_value

func _on_stamina_changed(new_stamina: float) -> void:
	stamina_bar.value = new_stamina * stamina_bar.max_value

func _on_hunger_changed(new_hunger: float) -> void:
	hunger_bar.value = new_hunger * hunger_bar.max_value

func _on_coldness_changed(new_coldness: float) -> void:
	coldness_bar.value = new_coldness * coldness_bar.max_value

func _on_player_died() -> void:
	death_screen.visible = true

func _on_try_again_pressed():
	var err := get_tree().reload_current_scene()
	assert(err == OK)

func _on_main_menu_pressed():
	var err := get_tree().change_scene("res://main_menu/main_menu.tscn")
	assert(err == OK)
