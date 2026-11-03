extends Node3D

signal game_defeated(monster_id: int)

@export var victory_overlay: Control
@export var audio_controller: Node3D

@export var victory_delay: float = 3.0

enum GameState {
	PLAYING,
	VICTORY,
	DEFEAT
}

var state := GameState.PLAYING

func victory() -> void:
	if state != GameState.PLAYING:
		return

	state = GameState.VICTORY
	
	audio_controller.play_victory()
	victory_overlay.show()
	
	await audio_controller.sfx_player.finished

	

	get_tree().change_scene_to_file("res://scenes/victory.tscn")

func defeat(monster: Node3D) -> void:
	if state != GameState.PLAYING:
		return

	state = GameState.DEFEAT

	print("Morto por: ", monster.name)

func _on_night_controller_night_finished() -> void:
	victory()
