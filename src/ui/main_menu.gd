extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var options_panel: Control = $OptionsPanel
@export_file("*.tscn") var spawn_scene: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_buttons.visible = true
	options_panel.visible = false

	SignalBus.play_game_music.emit("menu")


func _on_start_button_pressed() -> void:
	GameState.reset()
	get_tree().change_scene_to_file("res://scene/ui/Tutorial Screen.tscn")


func _on_options_button_pressed() -> void:
	main_menu_buttons.visible = false
	options_panel.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	main_menu_buttons.visible = true
	options_panel.visible = false


func _on_fullscreen_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_audio_h_slider_value_changed(new_volume: float) -> void:
	if not options_panel.visible:
		return

	SignalBus.music_volume_changed.emit(new_volume)
