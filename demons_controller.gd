class_name DemonsController
extends Node3D

enum Location {
	CAM_LEFT,
	CAM_RIGHT,
	DOOR_LEFT,
	DOOR_RIGHT,
	OFFICE,
	SALA,
	JUMPSCARE
}

var connections = {
	Location.CAM_LEFT: [
		Location.DOOR_LEFT,
		Location.SALA
	],

	Location.CAM_RIGHT: [
		Location.DOOR_RIGHT,
		Location.SALA
	],

	Location.DOOR_LEFT: [
		Location.OFFICE
	],

	Location.DOOR_RIGHT: [
		Location.OFFICE
	],
	
	Location.SALA : [
		Location.CAM_LEFT,
		Location.CAM_RIGHT
	]
	
}

var positions = {}
