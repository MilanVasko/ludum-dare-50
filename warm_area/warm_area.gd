extends Area2D

export(float) var warmth_per_second

func arrive(subject: Node2D) -> void:
	if subject.has_method("_on_warm_area_arrive"):
		subject._on_warm_area_arrive(warmth_per_second)

func leave(subject: Node2D) -> void:
	if subject.has_method("_on_warm_area_leave"):
		subject._on_warm_area_leave(warmth_per_second)
