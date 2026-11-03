extends Monster

@export var markers: Array[Marker3D]
@export var move_timer: Timer
@export var attack_position: Vector3
@export var kitchen_door: Node3D
@export var jumpscare_position: Marker3D

const DOOR_MARKER := "Escada"
const JUMPSCARE_MARKER := "Jumpscare"

var current_position: int = 0


func _ready() -> void:
	global_transform = markers[0].global_transform
	print(monster_controller)


func _on_move_timer_timeout() -> void:
	try_move()
	print("arroz")


func try_move() -> void:
	var chance := randf()

	if chance < 1:
		move_to_next_position()

func move_to_next_position() -> void:
	var current_marker = markers[current_position]
	
	if current_position + 1 >= markers.size():
		return
	
	if current_marker.name == DOOR_MARKER:
		check_door()
		return
	move_to_position(current_position + 1)

func move_to_position(position_index: int) -> void:
	if position_index < 0 or position_index >= markers.size():
		return

	global_transform = markers[position_index].global_transform
	current_position = position_index

func check_door() -> void:
	if kitchen_door.is_open:
		start_jumpscare()
	else:
		move_to_position(0)

func start_jumpscare() -> void:
	monster_controller.jumpscare_signal(self)

	move_to_position(markers.size()-1)
	
	await get_tree().create_timer(2.0).timeout
	
	var tween := create_tween()

	tween.tween_property(
		self,
		"global_position",
		attack_position,
		0.2
	)

	await tween.finished

	#game_controller.defeat()
