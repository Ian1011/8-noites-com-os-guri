class_name PlayerViewController
extends Node

@export var player_cam: Camera3D
@export var left_view: Marker3D
@export var center_view: Marker3D
@export var right_view: Marker3D
@export var cameras_controller: Node3D
@export var controle_acoes: Node3D

@export var turn_duration: float = 0.3

var is_turning: bool = false

enum ViewPosition {
	LEFT,
	CENTER,
	RIGHT
}

var current_view: ViewPosition = ViewPosition.CENTER

func _input(event: InputEvent) -> void:
	if not controle_acoes.can_act():
			return

	if cameras_controller.using_monitor:
		return
	
	if event.is_action_pressed("look_left"):
		change_view(-1)

	if event.is_action_pressed("look_right"):
		change_view(1)

func change_view(direction: int) -> void:
	if is_turning:
		return

	var new_view := clampi(
		int(current_view) + direction,
		ViewPosition.LEFT,
		ViewPosition.RIGHT
	)

	if new_view == current_view:
		return

	current_view = new_view
	move_to_current_view()

func move_to_current_view() -> void:
	var target: Marker3D

	match current_view:
		ViewPosition.LEFT:
			target = left_view

		ViewPosition.CENTER:
			target = center_view

		ViewPosition.RIGHT:
			target = right_view

	is_turning = true

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)

	tween.tween_property(
		player_cam,
		"global_position",
		target.global_position,
		turn_duration
	)

	tween.tween_property(
		player_cam,
		"global_rotation",
		target.global_rotation,
		turn_duration
	)

	await tween.finished

	is_turning = false
