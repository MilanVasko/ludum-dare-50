extends Node2D

var player: Node2D
var exit: Node2D
onready var arrow := $Arrow
var time_accum := 0.0

func _ready() -> void:
	visible = false

func _on_exit_spawned(exit: Node2D, player: Node2D) -> void:
	self.exit = exit
	self.player = player
	visible = true

func _process(delta: float) -> void:
	if player != null && exit != null:
		update_appearance(delta)

func update_appearance(delta: float) -> void:
	visible = player.global_position.distance_squared_to(exit.global_position) > arrow.position.length_squared()
	look_at(exit.global_position)
	time_accum = fmod(time_accum + (delta * 2), PI * 2)
	arrow.scale = Vector2.ONE * (abs(sin(time_accum) * 0.2) + 0.5)
