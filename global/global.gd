extends Node

const WALKING_SPEED := 300.0
const RUNNING_SPEED := 500.0
const COLDNESS_FILL_PER_SECOND := 0.025
const COLDNESS_HEALTH_DECAY_PER_SECOND := 0.01
const HUNGER_FILL_PER_SECOND := 0.015
const HUNGER_HEALTH_DECAY_PER_SECOND := 0.005
const STAMINA_REPLENISH_PER_SECOND := 0.1
const STAMINA_DECAY_PER_SECOND := 0.2
const STAMINA_USABLE_AGAIN_THRESHOLD := 0.2
const GOOD_STATE_HEALTH_BONUS_PER_SECOND := 0.05
const BUILDING_WARMTH_PER_SECOND := 0.15
const FIRE_WARMTH_PER_SECOND := 0.15
const FIRE_DAMAGE_PER_SECOND := 0.5
const FOOD_SPAWN_CHANCE := 0.3

const ENEMY_ROTATION_SPEED := 1.0
const ENEMY_TURN_SPEED := 4.0
const ENEMY_DETECTION_PROGRESS_PER_SECOND := 1.5
const ENEMY_DETECTION_COOLDOWN_PER_SECOND := 0.2
const ENEMY_PATROL_PAUSE := 3.0

const RADIO_TEXT_DISPLAY_TIME := 2.0

const LAYER_WARM_AREA := 0b10

func _ready():
	randomize()

func is_any_object_visible(beholder: Node2D, subject: CollisionObject2D) -> bool:
	return beholder.get_world_2d().direct_space_state.intersect_ray(
		beholder.global_position,
		subject.global_position,
		[],
		~Global.LAYER_WARM_AREA,
		true,
		true
	)["collider"] == subject

func is_material_object_visible(beholder: Node2D, subject: CollisionObject2D) -> bool:
	return beholder.get_world_2d().direct_space_state.intersect_ray(
		beholder.global_position,
		subject.global_position,
		[],
		~Global.LAYER_WARM_AREA,
		true,
		false
	)["collider"] == subject
