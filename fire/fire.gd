extends Area2D

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("_on_fire_entered"):
		body._on_fire_entered()


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.has_method("_on_fire_exited"):
		body._on_fire_exited()
