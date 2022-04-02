extends Node2D

export(Array) var textures: Array

func _ready():
	var sprite: Sprite = $Sprite
	sprite.texture = textures[randi() % textures.size()]
	sprite.rotation = randf() * deg2rad(360.0)
	sprite.scale = Vector2.ONE * max(randf(), 0.7)
