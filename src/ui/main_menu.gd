extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var options_panel: Panel = $OptionsPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_buttons.visible = true
	options_panel.visible = false


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/playtest.tscn")


func _on_options_button_pressed() -> void:
	main_menu_buttons.visible = false
	options_panel.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	_ready()


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
