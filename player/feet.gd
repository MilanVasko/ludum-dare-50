extends Area2D

export(NodePath) var player_path
onready var player := get_node(player_path)

func _on_object_entered(obj: CollisionObject2D) -> void:
	if obj.has_method("arrive"):
		obj.arrive(player)

func _on_object_exited(obj: CollisionObject2D) -> void:
	if obj.has_method("leave"):
		obj.leave(player)
