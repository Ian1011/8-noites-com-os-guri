class_name NightController
extends Node

signal hour_changed(hour: int)
signal night_finished

@export var hour_duration: float = 60
@export var total_hours: int = 8
@export var hour_label: Label

var current_hour: int = 0
var elapsed_time: float = 0.0
var finished: bool = false

func _ready() -> void:
	update_hour_label()

func _process(delta: float) -> void:
	elapsed_time += delta
	
	var new_hour := int(elapsed_time / hour_duration)
	
	if new_hour != current_hour:
		current_hour = new_hour
		hour_changed.emit(current_hour)
		update_hour_label()
	
	if current_hour >= total_hours:
		finish_night()

func finish_night() -> void:
	if finished:
		return

	finished = true
	elapsed_time = 480.0
	set_process(false)

	# garante que o HUD mostre a hora final
	update_hour_label()

	night_finished.emit()
	
func update_hour_label() -> void:
	if current_hour == 0:
		hour_label.text = "12 AM"
	else:
		hour_label.text = str(current_hour) + " AM"
