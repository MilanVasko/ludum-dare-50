extends Node2D

onready var bar := $ProgressBar

func _process(_delta: float) -> void:
	global_rotation = 0

func _on_detection_progress_changed(new_progress: float) -> void:
	bar.visible = new_progress != 0.0
	bar.value = new_progress * bar.max_value
