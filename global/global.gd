extends Node

const WALKING_SPEED := 200.0
const RUNNING_SPEED := 350.0
const COLDNESS_FILL_PER_SECOND := 0.025
const COLDNESS_HEALTH_DECAY_PER_SECOND := 0.005
const HUNGER_FILL_PER_SECOND := 0.015
const HUNGER_HEALTH_DECAY_PER_SECOND := 0.0025
const STAMINA_REPLENISH_PER_SECOND := 0.1
const STAMINA_DECAY_PER_SECOND := 0.2
const GOOD_STATE_HEALTH_BONUS_PER_SECOND := 0.05
const BUILDING_WARMTH_PER_SECOND := 0.15
const FIRE_WARMTH_PER_SECOND := 0.15
const FIRE_DAMAGE_PER_SECOND := 0.2
const FOOD_SPAWN_CHANCE := 0.3

const ENEMY_ROTATION_SPEED := 1
const ENEMY_DETECTION_PROGRESS_PER_SECOND := 0.5
const ENEMY_DETECTION_COOLDOWN_PER_SECOND := 0.2

const RADIO_TEXT_DISPLAY_TIME := 2.0

func _ready():
	randomize()
