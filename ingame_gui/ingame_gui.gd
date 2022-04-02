extends Control

onready var health_bar := $Stats/Health/ProgressBar
onready var hunger_bar := $Stats/Hunger/ProgressBar
onready var coldness_bar := $Stats/Coldness/ProgressBar

func _on_health_changed(new_health: float) -> void:
	health_bar.value = new_health * health_bar.max_value

func _on_hunger_changed(new_hunger: float) -> void:
	hunger_bar.value = new_hunger * hunger_bar.max_value

func _on_coldness_changed(new_coldness: float) -> void:
	coldness_bar.value = new_coldness * coldness_bar.max_value

