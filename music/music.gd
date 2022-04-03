extends Node2D

const DISTANCE_THRESHOLD = 1000

const MAX_AMBIENT_VOLUME = -5
const MIN_AMBIENT_VOLUME = -40

const MAX_ENEMY_VOLUME = 10
const MIN_ENEMY_VOLUME = -40

onready var enemies := get_tree().get_nodes_in_group("enemy")
onready var player: Node2D = get_tree().get_nodes_in_group("player")[0]

func _process(_delta: float) -> void:
	var closest_enemy_distance := find_closest_enemy_distance()
	var enemy_close_bus_index := AudioServer.get_bus_index("EnemyCloseMusic")
	var ambient_bus_index := AudioServer.get_bus_index("AmbientMusic")
	AudioServer.set_bus_volume_db(enemy_close_bus_index, transform_distance_to_enemy_db(closest_enemy_distance))
	AudioServer.set_bus_volume_db(ambient_bus_index, transform_distance_to_ambient_db(closest_enemy_distance))

func transform_distance_to_enemy_db(distance: float) -> float:
	return lerp(MAX_ENEMY_VOLUME, MIN_ENEMY_VOLUME, clamp(distance / DISTANCE_THRESHOLD, 0, 1))

func transform_distance_to_ambient_db(distance: float) -> float:
	return lerp(MIN_AMBIENT_VOLUME, MAX_AMBIENT_VOLUME, clamp(distance / DISTANCE_THRESHOLD, 0, 1))

func find_closest_enemy_distance() -> float:
	var closest_enemy: Node2D = null
	var closest_enemy_squared_distance = INF
	for enemy in enemies:
		var squared_distance := player.global_position.distance_squared_to(enemy.global_position)
		if squared_distance < closest_enemy_squared_distance:
			closest_enemy_squared_distance = squared_distance
			closest_enemy = enemy
	assert(closest_enemy != null)
	return sqrt(closest_enemy_squared_distance)
