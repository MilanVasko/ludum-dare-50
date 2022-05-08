extends Area2D

signal detection_progress_changed(detection_progress)
signal detected(subject)
signal seen_start(subject)
signal seen_end()

var potential_seen_subject: Node2D = null
var is_subject_seen := false
var detection_progress := 0.0

func _ready() -> void:
	emit_signal("detection_progress_changed", detection_progress)

func arrive(subject: Node2D) -> void:
	# TODO: refactor "player" group out of here?
	if subject.is_in_group("player"):
		potential_seen_subject = subject
		is_subject_seen = Global.is_material_object_visible(self, subject)
		if is_subject_seen:
			emit_signal("seen_start", potential_seen_subject)

func leave(subject: Node2D) -> void:
	if subject == potential_seen_subject:
		is_subject_seen = Global.is_material_object_visible(self, subject)
		potential_seen_subject = null
		if is_subject_seen:
			emit_signal("seen_end")
		is_subject_seen = false

func _physics_process(delta: float) -> void:
	if potential_seen_subject != null:
		update_seen_and_emit_signals()

	if is_subject_seen:
		if detection_progress < 1.0:
			detection_progress += Global.ENEMY_DETECTION_PROGRESS_PER_SECOND * delta
			emit_signal("detection_progress_changed", detection_progress)
			if detection_progress >= 1.0:
				emit_signal("detected", potential_seen_subject)
	else:
		if detection_progress > 0.0:
			detection_progress = max(detection_progress - Global.ENEMY_DETECTION_COOLDOWN_PER_SECOND * delta, 0)
			emit_signal("detection_progress_changed", detection_progress)

func update_seen_and_emit_signals() -> void:
	var previous_is_subject_seen := is_subject_seen
	is_subject_seen = Global.is_material_object_visible(self, potential_seen_subject)
	if previous_is_subject_seen != is_subject_seen:
		if is_subject_seen:
			emit_signal("seen_start", potential_seen_subject)
		else:
			emit_signal("seen_end")
