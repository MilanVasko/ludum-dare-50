extends Light2D

export(Color) var good_color: Color
export(Color) var bad_color: Color

func _ready() -> void:
	color = good_color

func _on_detection_progress_changed(new_progress: float) -> void:
	print("WTF ", new_progress)
	color = lerp(good_color, bad_color, new_progress)
