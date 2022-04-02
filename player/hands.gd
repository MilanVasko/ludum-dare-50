extends Node2D

var close_usable_object: Node2D = null

func _process(_delta: float) -> void:
	if close_usable_object != null && Input.is_action_just_pressed("use"):
		close_usable_object.use()

func _on_object_entered(body: CollisionObject2D) -> void:
	object_entered(body)

func _on_object_exited(body: CollisionObject2D) -> void:
	object_exited(body)

func _on_area_entered(area: CollisionObject2D) -> void:
	object_entered(area)

func _on_area_exited(area: CollisionObject2D) -> void:
	object_exited(area)

func object_entered(obj: CollisionObject2D) -> void:
	if obj.has_method("use"):
		close_usable_object = obj

func object_exited(obj: CollisionObject2D) -> void:
	if close_usable_object == obj:
		close_usable_object = null
