extends Area2D

signal detection_progress_changed(detection_progress)
signal detected(subject)
signal seen_start(subject)
signal seen_end()

var seen_subject: Node2D = null
var detection_progress := 0.0

func _ready() -> void:
	emit_signal("detection_progress_changed", detection_progress)

func arrive(subject: Node2D) -> void:
	# TODO: refactor "player" group out of here?
	if subject.is_in_group("player"):
		seen_subject = subject
		emit_signal("seen_start", seen_subject)

func leave(subject: Node2D) -> void:
	if subject == seen_subject:
		seen_subject = null
		emit_signal("seen_end")

func _process(delta: float) -> void:
	if seen_subject != null:
		if detection_progress < 1.0:
			detection_progress += Global.ENEMY_DETECTION_PROGRESS_PER_SECOND * delta
			emit_signal("detection_progress_changed", detection_progress)
			if detection_progress >= 1.0:
				emit_signal("detected", seen_subject)
	else:
		if detection_progress > 0.0:
			detection_progress = max(detection_progress - Global.ENEMY_DETECTION_COOLDOWN_PER_SECOND * delta, 0)
			emit_signal("detection_progress_changed", detection_progress)
