extends Sprite3D

signal player_caught

@onready var demons_controller: DemonsController = $".."
@onready var current_location: DemonsController.Location = DemonsController.Location.SALA
@onready var door_right: Node3D = $"../../Office/Doors/DoorRight"
@onready var door_left: Node3D = $"../../Office/Doors/DoorLeft"
@onready var night: NIGHT = $"../.."
@onready var jumpscare: Timer = $JumpscareT
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func move_demon():
	if current_location == DemonsController.Location.OFFICE or not night.player_live:
		return
	
	var possibles_positions = demons_controller.connections[current_location]
	var new_position = possibles_positions[randi_range(0, possibles_positions.size()-1)]
	
	if new_position == DemonsController.Location.OFFICE:
		var door: Node3D
		match current_location:
			DemonsController.Location.DOOR_LEFT:
				door = door_left
			DemonsController.Location.DOOR_RIGHT:
				door = door_right
		if not door.is_open:
			new_position = DemonsController.Location.SALA

	current_location = new_position
	
	var marker = demons_controller.positions[current_location]
	global_position = marker.global_position
	global_rotation = marker.global_rotation
	
	if current_location == DemonsController.Location.OFFICE:
		emit_signal("player_caught") 


func _on_timer_timeout() -> void:
	move_demon()


func _on_jumpscare_timeout() -> void:
	current_location = DemonsController.Location.JUMPSCARE
	var marker = demons_controller.positions[current_location]
	
	audio_stream_player.play(0)
	var tween = create_tween()
	tween.tween_property(
		self,
		"global_transform",
		marker.global_transform,
		0.1
	)
