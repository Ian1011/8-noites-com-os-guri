extends Control

@export_file("*.tscn") var game_scene: String


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)
