extends Light2D

export(Color) var good_color: Color
export(Color) var bad_color: Color

func _ready() -> void:
	color = good_color

func update_progress(new_progress: float) -> void:
	color = lerp(good_color, bad_color, new_progress)
