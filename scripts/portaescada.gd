extends Node3D

@export var open_height: float
@export var closed_height: float
@export var move_time: float = 0.3

var is_open: bool = true
var is_moving: bool = false

func toggle() -> void:
	if is_moving:
		return

	is_open = not is_open
	is_moving = true

	var target_height: float

	if is_open:
		target_height = open_height
	else:
		target_height = closed_height

	var tween = create_tween()

	tween.tween_property(
		self,
		"position:y",
		target_height,
		move_time
	)

	await tween.finished
	is_moving = false
