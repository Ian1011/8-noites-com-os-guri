extends Node3D

@export_category('Controls')
@export var game_controller: Node3D
@export var audio_controller: Node3D
@export var actions_controller: Node3D

func jumpscare_signal(monster: Node3D):
	actions_controller._on_defeated(monster)
