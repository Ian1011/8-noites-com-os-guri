extends Node3D

@onready var demons_controller: Node3D = $".."

@export var office_pos: Marker3D
@export var corredor_left_pos: Marker3D
@export var corredor_right_pos: Marker3D
@export var door_right_pos: Marker3D
@export var door_left_pos: Marker3D
@export var sala_pos: Marker3D
@export var jumpscare_pos: Marker3D


func _ready():
	demons_controller.positions = {
		demons_controller.Location.CAM_LEFT: corredor_left_pos,
		demons_controller.Location.CAM_RIGHT: corredor_right_pos,
		demons_controller.Location.OFFICE: office_pos,
		demons_controller.Location.DOOR_RIGHT: door_right_pos,
		demons_controller.Location.DOOR_LEFT: door_left_pos,
		demons_controller.Location.SALA: sala_pos,
		demons_controller.Location.JUMPSCARE: jumpscare_pos
	}
