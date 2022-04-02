extends Control

onready var health_bar := $Bottom/Stats/Health/ProgressBar
onready var stamina_bar := $Bottom/Stats/Stamina/ProgressBar
onready var hunger_bar := $Bottom/Stats/Hunger/ProgressBar
onready var coldness_bar := $Bottom/Stats/Coldness/ProgressBar
onready var use_label := $Bottom/Use/Label
onready var death_screen := $DeathScreen
onready var win_screen := $WinScreen

func _ready():
	death_screen.visible = false
	win_screen.visible = false
	use_label.visible = false

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

func _on_play_again_pressed():
	var err := get_tree().reload_current_scene()
	assert(err == OK)

func _on_main_menu_pressed():
	var err := get_tree().change_scene("res://main_menu/main_menu.tscn")
	assert(err == OK)

func _on_usable_object_entered():
	use_label.visible = true

func _on_usable_object_exited():
	use_label.visible = false

func _on_exit_reached():
	win_screen.visible = true
