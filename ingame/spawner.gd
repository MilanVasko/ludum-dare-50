extends Node2D

var food_scene := preload("res://food/food.tscn")
var radio_scene := preload("res://radio/radio.tscn")

func _ready() -> void:
	var potential_food_spawn_points := get_tree().get_nodes_in_group("food_spawn_point")
	print("Food spawn point count: ", potential_food_spawn_points.size())
	var food_count := 0
	for food_spawn_point in potential_food_spawn_points:
		if randf() < Global.FOOD_SPAWN_CHANCE:
			var food := food_scene.instance()
			food_spawn_point.add_child(food)
			food_count += 1
	print("Spawned food: ", food_count)

	var potential_radio_spawn_points := get_tree().get_nodes_in_group("radio_spawn_point")
	print("Radio spawn point count: ", potential_radio_spawn_points.size())
	var radio_spawn_point: Node2D = potential_radio_spawn_points[randi() % potential_radio_spawn_points.size()]
	var radio := radio_scene.instance()
	radio_spawn_point.add_child(radio)
