class_name VideoController
extends Node

signal video_depleted
signal video_started
signal video_stopped
signal video_ready

@export var max_video: float = 100.0
@export var drain_rate: float = 0.25
@export var play_duration: float = 10.0
@export var cooldown_duration: float = 5.0

@export var video_progress: ProgressBar
@export var audio_controller: Node3D
@export var tv_light: SpotLight3D

var video_level: float
var depleted: bool = false

var is_playing: bool = false
var video_available: bool = true

func _ready() -> void:
	video_level = max_video
	update_bar()


func _process(delta: float) -> void:
	if depleted:
		return

	if is_playing:
		return

	video_level -= drain_rate * delta
	video_level = max(video_level, 0.0)

	update_bar()

	if video_level <= 0:
		deplete_video()

func play_video() -> void:
	if depleted:
		return

	if not video_available:
		return

	video_available = false
	is_playing = true
	video_started.emit()
	audio_controller.play_random_video()

	await get_tree().create_timer(play_duration).timeout

	is_playing = false
	video_stopped.emit()

	await get_tree().create_timer(cooldown_duration).timeout
	
	audio_controller.stop_video()

	video_available = true
	video_ready.emit()

func update_bar() -> void:
	video_progress.value = video_level


func deplete_video() -> void:
	depleted = true
	video_depleted.emit()
	tv_light.hide()
	print("VIDEO ESGOTADO - MONSTRO 5 LIVRE")
