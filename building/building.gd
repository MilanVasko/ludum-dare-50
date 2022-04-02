extends StaticBody2D

func _ready():
	$WarmArea.warmth_per_second = Global.BUILDING_WARMTH_PER_SECOND
