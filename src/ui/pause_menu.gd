extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func show_pause_menu():
	visible = true
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	GameState.reset()
	GameState.player_is_dead = true
	get_tree().paused = false

	var scene_path = "res://scene/rooms/{z}/{r}".format({"z": GameState.current_player_zone, "r": "spawn_room.tscn"})

	print(scene_path)

	get_tree().change_scene_to_file(scene_path)


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	GameState.reset()
	GameState.has_dj = false
	get_tree().change_scene_to_file("res://scene/ui/main_menu.tscn")


func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			show_pause_menu()
		
