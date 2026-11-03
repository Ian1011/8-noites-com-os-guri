extends Node

@export var main_cam: Camera3D
@export var security_cameras: Array[Camera3D]
@export var camera_UI: Control
@export var no_signal: ColorRect
@export var camera_action: BaseButton
@export var video_progress: ProgressBar
@export var controle_acoes: Node3D
@export var video_controller: VideoController
@export var tablet_animation: AnimationPlayer
@export var audio_controller: Node3D
@export var energy_controller: Node3D


var current_camera: int = -1
var using_monitor: bool = false

enum CameraAction {
	NONE,
	FLASH,
	BAIT,
	VIDEO
}

var camera_actions = [
	CameraAction.FLASH,
	CameraAction.FLASH,
	CameraAction.BAIT,
	CameraAction.NONE,
	CameraAction.NONE,
	CameraAction.VIDEO,
	CameraAction.NONE
]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			check_bear_nose(event.position)

func set_camera_light(enabled: bool) -> bool:
	if not using_monitor or current_camera < 0:
		return false

	var cam: Camera3D = security_cameras[current_camera]
	var camera_light: SpotLight3D = cam.get_node_or_null("LightCam")

	if camera_light:
		camera_light.visible = enabled
		return enabled

	return false

func check_bear_nose(mouse_position: Vector2) -> void:
	var from := main_cam.project_ray_origin(mouse_position)
	var direction := main_cam.project_ray_normal(mouse_position)
	var to := from + direction * 100.0

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true

	var result := main_cam.get_world_3d().direct_space_state.intersect_ray(query)

	if result.is_empty():
		return

	var collider: Object = result["collider"]
	if collider.is_in_group("bear_nose"):
		audio_controller.play_bear_honk()

func open_camera(index: int):
	if not controle_acoes.can_act():
			return
	
	if index < 0 or index >= security_cameras.size():
		return
	
	set_camera_light(false)
	
	if using_monitor:
		audio_controller.play_camera_switch()

	camera_UI.show()
	current_camera = index
	using_monitor = true
	security_cameras[index].make_current()
	
	if index == 6:
		no_signal.show()
	else:
		no_signal.hide()
		
	update_action_button()
	
func close_cameras():
	set_camera_light(false)
	
	using_monitor = false
	camera_UI.hide()
	no_signal.hide()
	tablet_animation.play_backwards("TABLET_UP")
	current_camera = -1
	main_cam.make_current()
	

func update_action_button() -> void:
	if not using_monitor or current_camera < 0:
		camera_action.hide()
		return
	var action = camera_actions[current_camera]

	video_progress.hide()
	match action:
		CameraAction.NONE:
			camera_action.hide()

		CameraAction.FLASH:
			camera_action.show()

			if controle_acoes.flash_available:
				camera_action.disabled = false
				camera_action.text = "SHOCK"
			else:
				camera_action.disabled = true
				camera_action.text = "RECHARGING..."

		CameraAction.BAIT:
			camera_action.show()

			if controle_acoes.bait_available:
				camera_action.disabled = false
				camera_action.text = "PLAY BAIT"
			else:
				camera_action.disabled = true
				camera_action.text = "COOLDOWN..."

		CameraAction.VIDEO:
			video_progress.show()

			if video_controller.depleted:
				camera_action.hide()

			elif video_controller.is_playing:
				camera_action.show()
				camera_action.disabled = true
				camera_action.text = "PLAYING..."

			elif not video_controller.video_available:
				camera_action.show()
				camera_action.disabled = true
				camera_action.text = "COOLDOWN..."

			else:
				camera_action.show()
				camera_action.disabled = false
				camera_action.text = "PLAY VIDEO"

func _on_flash_ready() -> void:
	update_action_button()

func _on_bait_started() -> void:
	update_action_button()

func _on_bait_cooldown_started() -> void:
	update_action_button()

func _on_bait_ready() -> void:
	update_action_button()

func _on_video_started() -> void:
	update_action_button()

func _on_video_stopped() -> void:
	update_action_button()

func _on_video_ready() -> void:
	update_action_button()

func _on_video_depleted() -> void:
	update_action_button()

func _ready() -> void:
	controle_acoes.bait_started.connect(_on_bait_started)
	controle_acoes.bait_cooldown_started.connect(_on_bait_cooldown_started)
	controle_acoes.bait_ready.connect(_on_bait_ready)
	video_controller.video_started.connect(_on_video_started)
	video_controller.video_stopped.connect(_on_video_stopped)
	video_controller.video_ready.connect(_on_video_ready)
	video_controller.video_depleted.connect(_on_video_depleted)

# 1 - Cozinha
# 2 - Garagem
# 3 - Quintal
# 4 - Corredor
# 5 - Quarto A
# 6 - Quarto B
# 7 - Escritorio

func _on_button_pressed() -> void:
	open_camera(0)

func _on_button_2_pressed() -> void:
	open_camera(1)

func _on_button_3_pressed() -> void:
	open_camera(2)

func _on_button_4_pressed() -> void:
	open_camera(3)

func _on_button_5_pressed() -> void:
	open_camera(4)

func _on_button_6_pressed() -> void:
	open_camera(5)

func _on_button_7_pressed() -> void:
	open_camera(6)
	if randf() <= 0.18:
		audio_controller.play_random_office_meme()

func _on_camera_action_pressed() -> void:
	if not controle_acoes.can_act():
			return

	var action = camera_actions[current_camera]

	match action:
		CameraAction.FLASH:
			audio_controller.play_shock()
			controle_acoes.use_camera_flash()

		CameraAction.BAIT:
			controle_acoes.use_bait()

		CameraAction.VIDEO:
			controle_acoes.play_video()
