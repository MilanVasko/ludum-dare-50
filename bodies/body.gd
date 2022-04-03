extends Sprite

export(Array) var textures

func _ready():
	texture = textures[randi() % textures.size()]
	rotation = randf() * deg2rad(360)
