extends Area2D

export(float) var damage_per_second

func arrive(subject: Node2D) -> void:
	if subject.has_method("_on_dangerous_area_arrive"):
		subject._on_dangerous_area_arrive(damage_per_second)

func leave(subject: Node2D) -> void:
	if subject.has_method("_on_dangerous_area_leave"):
		subject._on_dangerous_area_leave(damage_per_second)
