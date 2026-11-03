class_name NIGHT
extends Node3D
@onready var player_cameras: Node3D = $PlayerCameras
@onready var sprite_3d: Sprite3D = $DemonsController/Sprite3D

var player_live: bool = true



func _on_sprite_3d_player_caught() -> void:
	player_live = false
	player_cameras.office_cam.make_current()
	sprite_3d.jumpscare.start()
