tool
extends Node2D

export(Rect2) var rect: Rect2
export(int) var trash_count: int

func _ready() -> void:
	if !Engine.editor_hint:
		generate_trash()

func generate_trash() -> void:
	for _i in range(trash_count):
		spawn_trash_at_position(Vector2(
			rect.position.x + (randf() * rect.end.x),
			rect.position.y + (randf() * rect.end.y)
		))

func spawn_trash_at_position(pos: Vector2) -> void:
	var random_trash_scene := preload("res://random_trash/random_trash.tscn")
	var random_trash = random_trash_scene.instance()
	add_child(random_trash)
	random_trash.position = pos

func _draw() -> void:
	if Engine.editor_hint:
		draw_rect(rect, Color.red, false, 2.0)

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		update()
