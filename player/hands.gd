extends Node2D

export(NodePath) var player_path
onready var player := get_node(player_path)
var close_usable_object: Node2D = null

func _process(_delta: float) -> void:
	if player.dead:
		return
	if close_usable_object != null && Input.is_action_just_pressed("use"):
		close_usable_object.use()
		if close_usable_object.has_method("can_use") && !close_usable_object.can_use():
			object_exited(close_usable_object)

func _on_object_entered(body: CollisionObject2D) -> void:
	object_entered(body)

func _on_object_exited(body: CollisionObject2D) -> void:
	object_exited(body)

func _on_area_entered(area: CollisionObject2D) -> void:
	object_entered(area)

func _on_area_exited(area: CollisionObject2D) -> void:
	object_exited(area)

func object_entered(obj: CollisionObject2D) -> void:
	if close_usable_object != null:
		object_exited(close_usable_object)

	if obj.has_method("use"):
		var can_use: bool = !obj.has_method("can_use") || obj.can_use()
		if can_use:
			close_usable_object = obj
			get_tree().call_group("usable_object_subscriber", "_on_usable_object_entered")

func object_exited(obj: CollisionObject2D) -> void:
	if close_usable_object == obj:
		close_usable_object = null
		get_tree().call_group("usable_object_subscriber", "_on_usable_object_exited")
