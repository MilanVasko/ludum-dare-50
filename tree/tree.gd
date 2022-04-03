extends Node2D

export(Array) var bottom_textures: Array
export(Array) var top_textures: Array
export(Array) var colors: Array

func _ready() -> void:
	var bottom := $Bottom
	bottom.texture = bottom_textures[randi() % bottom_textures.size()]
	bottom.rotation = randf() * deg2rad(360)
	bottom.modulate = colors[randi() % colors.size()]

	var middle := $Middle
	middle.texture = bottom_textures[randi() % bottom_textures.size()]
	middle.rotation = randf() * deg2rad(360)
	middle.modulate = colors[randi() % colors.size()]

	var top := $Top
	top.texture = top_textures[randi() % top_textures.size()]
	top.rotation = randf() * deg2rad(360)
	top.modulate = colors[randi() % colors.size()]
	
	scale = Vector2.ONE * (1 + (randf() * 0.2))
