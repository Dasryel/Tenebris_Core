extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GameState.player_died.connect(show_death_menu)

func show_death_menu():
	print("death menu")
	visible = true
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	GameState.reset()
	GameState.player_is_dead = true
	get_tree().paused = false

	var scene_path = "res://scene/rooms/{z}/{r}".format({"z": GameState.current_player_zone, "r": "spawn_room.tscn"})

	get_tree().change_scene_to_file(scene_path)


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	GameState.reset()
	GameState.has_dj = false
	get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")
