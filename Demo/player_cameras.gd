extends Node3D

@onready var office_cam: Camera3D = $OfficeCam
@onready var cam_01: Camera3D = $RightCam
@onready var cam_02: Camera3D = $LeftCam
@onready var cams = [office_cam, cam_01, cam_02]
@onready var cont = 0
@onready var night: NIGHT = $".."


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_cam") and night.player_live:
		if cont < cams.size() - 1:
			cont += 1
		else:
			cont = 0
		cams[cont].make_current()
