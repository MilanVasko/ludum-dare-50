extends Area2D

func _on_object_entered(body: CollisionObject2D) -> void:
	object_entered(body)

func _on_object_exited(body: CollisionObject2D) -> void:
	object_exited(body)

func _on_area_entered(area: CollisionObject2D) -> void:
	object_entered(area)

func _on_area_exited(area: CollisionObject2D) -> void:
	object_exited(area)

func object_entered(obj: CollisionObject2D) -> void:
	if obj.has_method("arrive"):
		obj.arrive()

func object_exited(_obj: CollisionObject2D) -> void:
	# nothing
	pass
