extends Node2D

onready var label := $Label

var should_show_hints := true

func _ready() -> void:
	label.text = ""
	yield(get_tree().create_timer(40.0), "timeout")

	while true:
		if !should_show_hints:
			return
		label.text = "There must be a way to call help..."
		yield(get_tree().create_timer(2.0), "timeout")
		label.text = ""
		yield(get_tree().create_timer(10.0), "timeout")
		if !should_show_hints:
			return
		label.text = "Maybe there's a radio hidden somewhere\nin the remaining houses?"
		yield(get_tree().create_timer(2.0), "timeout")
		label.text = ""
		yield(get_tree().create_timer(15.0), "timeout")

func _process(_delta: float) -> void:
	global_rotation = 0.0

func _on_exit_spawned(_exit: Node2D, _player: Node2D) -> void:
	should_show_hints = false
