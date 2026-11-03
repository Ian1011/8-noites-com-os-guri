extends Node3D

@export var open_height: float
@export var closed_height: float
@onready var night: NIGHT = $"../../.."

var is_open: bool = true

func toggle_door():
	if not night.player_live:
		return
	var target_height: float
	is_open = not is_open
	if is_open:
		target_height = open_height
	else:
		target_height = closed_height
		
	var tween = create_tween()
	tween.tween_property(
		self,
		"position:y",
		target_height,
		0.8
)
  
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("right_door"):
		toggle_door()
