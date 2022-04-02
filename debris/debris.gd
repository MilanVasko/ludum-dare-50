extends Node2D

export(Array) var colors: Array

var debris_scenes := [
	preload("res://debris/debris1.tscn"),
	preload("res://debris/debris2.tscn"),
	preload("res://debris/debris3.tscn"),
	preload("res://debris/debris4.tscn"),
]

func _ready() -> void:
	var debris_scene: PackedScene = debris_scenes[randi() % debris_scenes.size()]
	var instance: Node2D = debris_scene.instance()
	instance.rotation = randf() * deg2rad(360.0)
	instance.scale = Vector2.ONE * max(randf(), 0.8)
	var sprite: Sprite = instance.get_node("Sprite")
	sprite.modulate = colors[randi() % colors.size()]
	add_child(instance)
