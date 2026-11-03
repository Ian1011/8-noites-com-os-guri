class_name EnergyController
extends Node

signal energy_depleted

@export var max_energy: float = 100.0

@export var base_consumption: float = 0.15
@export var monitor_consumption: float = 0.05
@export var door_consumption: float = 0.10
@export var flashlight_consumption: float = 0.05

@export var cameras_controller: Node
@export var stair_door: Node3D
@export var kitchen_door: Node3D
@export var energy_label: Label
@export var energy_bar: ProgressBar
@export var controle_acoes: Node3D
@export var audio_controller: Node3D

var energy: float
var depleted: bool = false

func _ready() -> void:
	energy = max_energy

func _process(delta: float) -> void:
	if depleted:
		return
	
	var consumption := base_consumption
	
	if cameras_controller.using_monitor:
		consumption += monitor_consumption
	
	if not stair_door.is_open:
		consumption += door_consumption
	
	if not kitchen_door.is_open:
		consumption += door_consumption
	
	if controle_acoes.flashlight_on or controle_acoes.camera_light_on:
		consumption += flashlight_consumption
	
	energy -= consumption * delta
	energy = max(energy, 0.0)
	
	update_energy_ui()

	if energy <= 0:
		deplete_energy()
		
func deplete_energy() -> void:
	if depleted:
		return

	depleted = true
	energy = 0.0

	energy_depleted.emit()
	audio_controller.play_power_down()
	
	await  audio_controller.sfx_player.finished
	print("BLACKOUT")
	
func update_energy_ui():
	energy_label.text = "POWER: " + str(roundi(energy)) + "%"
	energy_bar.value = energy

func consume_energy(amount: float) -> void:
	if depleted:
		return

	energy -= amount
	energy = max(energy, 0.0)

	update_energy_ui()

	if energy <= 0:
		deplete_energy()
