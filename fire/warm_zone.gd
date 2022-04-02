extends Area2D

func arrive(subject: Node2D) -> void:
	if subject.has_method("_on_warm_area_arrive"):
		subject._on_warm_area_arrive(Global.FIRE_WARMTH_PER_SECOND)

func leave(subject: Node2D) -> void:
	if subject.has_method("_on_warm_area_leave"):
		subject._on_warm_area_leave(Global.FIRE_WARMTH_PER_SECOND)
