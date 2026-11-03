extends Node

signal camera_flash_used(camera_index: int)
signal flash_used
signal flash_ready

signal bait_used
signal bait_started
signal bait_cooldown_started
signal bait_ready

@export_category('Controls')
@export var audio_controller: AudioController
@export var energy_controller: EnergyController
@export var game_controller: Node3D
@export var cameras_controller: Node
@export var video_controller: Node3D

@export_category('Outros')
@export var stair_door: Node3D
@export var kitchen_door: Node3D
@export var flash_effect: ColorRect
@export var flashlight: SpotLight3D
@export var main_cam: Camera3D
@export var flashlight_visual: Node3D
@export var flash_energy_cost: float = 0.5
@export var flash_cooldown_time: float = 1.0
@export var bait_duration: float = 5.0
@export var bait_cooldown: float = 10.0
@export var flashlight_distance: float = 20.0
@export var visual_max_rotation: float = 12.0
@export var visual_smoothness: float = 8.0

var flashlight_base_rotation: Vector3

var camera_light_on: bool = false
var bait_on_cooldown: bool = false
var flash_cooldown: bool = false
var bait_available: bool = true
var flash_available: bool = true
var flashlight_on: bool = false
var has_power: bool = true
var tablet_animating: bool = false

func _ready() -> void:
	flashlight_base_rotation = flashlight_visual.rotation

func _process(delta: float) -> void:
	if cameras_controller.using_monitor:
		return

	update_flashlight_aim()
	update_flashlight_visual(delta)

func _input(event: InputEvent) -> void:
	if not can_act():
			return
	
	if event.is_action_pressed("stair_door"):
		if not has_power:
			return

		if stair_door.is_open:
			audio_controller.play_door_close_s()
		stair_door.toggle()

	if event.is_action_pressed("kitchen_door"):
		if not has_power:
			return
		
		if kitchen_door.is_open:
			audio_controller.play_door_close_kitchen()

		kitchen_door.toggle()

	if event.is_action_pressed("flashlight"):
		if cameras_controller.using_monitor:
			cameras_controller.set_camera_light(true)
			camera_light_on = cameras_controller.set_camera_light(true)
		else:
			set_flashlight(true)
			audio_controller.play_flashlight()


	if event.is_action_released("flashlight"):
		cameras_controller.set_camera_light(false)
		camera_light_on = false
		set_flashlight(false)
		
	if event.is_action_pressed("monitor"):
		if not has_power:
			return

		if not cameras_controller.using_monitor:
			if tablet_animating:
				return

			audio_controller.play_monitor()
			tablet_animating = true

			cameras_controller.tablet_animation.play("TABLET_UP")
			await cameras_controller.tablet_animation.animation_finished
			
			tablet_animating = false
			cameras_controller.open_camera(0)
			set_flashlight(false)
		else:
			audio_controller.play_monitor()
			cameras_controller.close_cameras()


func can_act() -> bool:
	return game_controller.state == game_controller.GameState.PLAYING

func update_flashlight_aim() -> void:
	var mouse_pos := get_viewport().get_mouse_position()

	var ray_origin := main_cam.project_ray_origin(mouse_pos)
	var ray_direction := main_cam.project_ray_normal(mouse_pos)

	var target := ray_origin + ray_direction * flashlight_distance

	flashlight.look_at(target, Vector3.UP)

func use_camera_flash() -> void:
	if not has_power:
		return

	if not flash_available:
		return

	flash_available = false
	energy_controller.consume_energy(flash_energy_cost)

	var camera_index = cameras_controller.current_camera

	flash_used.emit(camera_index)

	flash_effect.show()
	await get_tree().create_timer(0.08).timeout
	flash_effect.hide()

	await get_tree().create_timer(flash_cooldown_time).timeout

	flash_available = true
	flash_ready.emit()

func use_bait() -> void:
	if not has_power:
		return

	if not bait_available:
		return

	bait_available = false

	bait_started.emit()
	bait_used.emit()
	audio_controller.play_bait()

	await get_tree().create_timer(bait_duration).timeout

	audio_controller.stop_bait()
	bait_cooldown_started.emit()

	await get_tree().create_timer(bait_cooldown).timeout

	bait_available = true
	bait_ready.emit()

func play_video() -> void:
	if not has_power:
		return

	video_controller.play_video()

func set_flashlight(value: bool) -> void:
	if not has_power:
		value = false
		
	if cameras_controller.using_monitor:
		value = false

	flashlight_on = value
	flashlight.visible = value

func update_flashlight_visual(delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var screen_size := get_viewport().get_visible_rect().size

	var normalized_x := (mouse_pos.x / screen_size.x) * 2.0 - 1.0
	var normalized_y := (mouse_pos.y / screen_size.y) * 2.0 - 1.0

	var max_angle := deg_to_rad(visual_max_rotation)

	var target_rotation := flashlight_base_rotation + Vector3(
		-normalized_y * max_angle,
		-normalized_x * max_angle,
		0.0
	)

	flashlight_visual.rotation = flashlight_visual.rotation.lerp(
		target_rotation,
		visual_smoothness * delta
	)

func _on_energy_depleted() -> void:
	has_power = false
	set_flashlight(false)
	
	if cameras_controller.using_monitor:
		cameras_controller.close_cameras()
		
	if not kitchen_door.is_open:
		kitchen_door.toggle()

	if not stair_door.is_open:
		stair_door.toggle()
		
	camera_light_on = cameras_controller.set_camera_light(false)
	
func _on_defeated(monster: Node3D) -> void:
	has_power = false
	set_flashlight(false)
	
	if cameras_controller.using_monitor:
		cameras_controller.close_cameras()
		
	camera_light_on = cameras_controller.set_camera_light(false)
	game_controller.defeat(monster)

func _on_energy_controller_energy_depleted() -> void:
	_on_energy_depleted()
