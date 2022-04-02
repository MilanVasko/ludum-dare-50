extends Node2D

export(float) var one_time_hunger_relief: float

func use(player: Node2D) -> void:
	player._on_food_eaten(one_time_hunger_relief)
	queue_free()
