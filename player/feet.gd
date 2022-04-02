extends Area2D

export(NodePath) var player_path
onready var player := get_node(player_path)

func _on_object_entered(body: CollisionObject2D) -> void:
	object_entered(body)

func _on_object_exited(body: CollisionObject2D) -> void:
	object_exited(body)

func _on_area_entered(area: CollisionObject2D) -> void:
	object_entered(area)

func _on_area_exited(area: CollisionObject2D) -> void:
	object_exited(area)

func object_entered(obj: CollisionObject2D) -> void:
	if player.dead:
		return
	if obj.has_method("arrive"):
		obj.arrive(player)

func object_exited(obj: CollisionObject2D) -> void:
	if player.dead:
		return
	if obj.has_method("leave"):
		obj.leave(player)
