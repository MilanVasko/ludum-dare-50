extends Area2D

export(float) var damage := 0.3

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("_on_fire_entered"):
		body.on_fire_entered(damage)


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.has_method("_on_fire_exited"):
		body.on_fire_exited(damage)
