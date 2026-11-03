extends SpotLight3D

@export var min_energy: float = 0.35
@export var max_energy: float = 1.1

@export var min_flicker_time: float = 0.03
@export var max_flicker_time: float = 0.12

var flicker_timer: float = 0.0


func _process(delta: float) -> void:
	flicker_timer -= delta

	if flicker_timer <= 0.0:
		light_energy = randf_range(min_energy, max_energy)
		flicker_timer = randf_range(
			min_flicker_time,
			max_flicker_time
		)
