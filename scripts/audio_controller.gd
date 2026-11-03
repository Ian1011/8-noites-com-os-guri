class_name AudioController
extends Node

@export_group("Memes")
@export var office_meme_sounds: Array[AudioStream]
@export var video_sounds: Array[AudioStream]
@export var aleatorios_sounds: Array[AudioStream]
@export var ambiente: AudioStream

@export_group("Sounds")
@export var vhs_sound: AudioStream
@export var bait_sound: AudioStream
@export var door_close_sound: AudioStream
@export var flashlight_turn: AudioStream
@export var shock_sound: AudioStream


@export_group("SFX")
@export var monitor_sound: AudioStream
@export var camera_switch_sound: AudioStream
@export var power_down_sound: AudioStream
@export var victory_sound: AudioStream
@export var bear_honk_sound: AudioStream

@export_group("Random Sounds")
@export var random_sounds: Array[AudioStream]
@export var random_players: Array[AudioStreamPlayer3D]

@export var min_random_delay: float = 30.0
@export var max_random_delay: float = 90.0

@onready var shock_player: AudioStreamPlayer = $ShockPlayer
@onready var flashlight_player: AudioStreamPlayer = $FlashlightPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var bait_player: AudioStreamPlayer = $BaitPlayer
@onready var doorK_player: AudioStreamPlayer= $DoorPlayerKitchen
@onready var doorS_player: AudioStreamPlayer = $DoorPlayerS
@onready var video_player: AudioStreamPlayer3D = $VideoPlayer
@onready var office_player: AudioStreamPlayer3D = $OfficePlayer
@onready var vhs_player: AudioStreamPlayer3D = $VhsPlayer
@onready var random_timer: Timer = $RandomTimer


func _ready() -> void:
	vhs_player.volume_db = 50
	vhs_player.max_distance = 40
	vhs_player.pitch_scale = 4
	vhs_player.stream = vhs_sound
	vhs_player.play()
	
	bait_player.stream = bait_sound
	
	doorK_player.stream = door_close_sound
	doorS_player.stream = door_close_sound
	
	music_player.stream = ambiente
	if music_player.stream is AudioStreamMP3:
		music_player.stream.loop = true
	music_player.play()
	
	flashlight_player.stream = flashlight_turn
	
	shock_player.stream = shock_sound
	
	_schedule_random_sound()

func _schedule_random_sound() -> void:
	random_timer.wait_time = randf_range(
		min_random_delay,
		max_random_delay
	)

	random_timer.start()

func play_random_office_meme():
	if office_meme_sounds.is_empty():
		return
		
	if office_player.playing:
		return

	var sound: AudioStream = office_meme_sounds.pick_random()

	office_player.stream = sound
	office_player.play()

func play_random_video() -> void:
	vhs_player.stop()

	if video_sounds.is_empty():
		return

	var sound: AudioStream = video_sounds.pick_random()

	video_player.stream = sound
	video_player.play()

func stop_video() -> void:
	video_player.stop()
	vhs_player.play()

func play_flashlight():
	flashlight_player.play()


func play_shock() -> void:
	shock_player.play()

func play_random_sound() -> void:
	if random_sounds.is_empty():
		return

	if random_players.is_empty():
		return

	var sound: AudioStream = random_sounds.pick_random()
	var player: AudioStreamPlayer3D = random_players.pick_random()

	player.stream = sound
	player.play()

func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return

	sfx_player.stream = stream
	sfx_player.play()

func play_bait() -> void:
	bait_player.stream = bait_sound
	bait_player.play()


func stop_bait() -> void:
	bait_player.stop()

func play_door_close_kitchen() -> void:
	doorK_player.play()


func play_door_close_s() -> void:
	doorS_player.play()


func play_monitor() -> void:
	play_sfx(monitor_sound)


func play_camera_switch() -> void:
	play_sfx(camera_switch_sound)


func play_power_down() -> void:
	play_sfx(power_down_sound)


func play_victory() -> void:
	play_sfx(victory_sound)


func play_bear_honk() -> void:
	play_sfx(bear_honk_sound)

func _on_random_timer_timeout() -> void:
	play_random_sound()
	_schedule_random_sound()
