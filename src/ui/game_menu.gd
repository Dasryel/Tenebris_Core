# game_menu.gd
extends Control

@export var title_label: Label
@export var resume_button: Button
@export var game_menu_panel: Panel
@export var options_panel: Panel

const IS_RESUMEABLE: bool = true
const NOT_RESUMEABLE: bool = false

var is_player_dead: bool = false

func _ready() -> void:
	visible = false
	GameState.player_died.connect(_on_player_died)


func _on_player_died() -> void:
	is_player_dead = true
	show_game_menu("YOU DIED!", Color.RED, NOT_RESUMEABLE)


func show_game_menu(text: String, color: Color, is_resumeable: bool):
	title_label.text = text
	title_label.add_theme_color_override("font_color", color)
	resume_button.visible = is_resumeable
	visible = true
	get_tree().paused = true


func _restart() -> void:
	GameState.reset()
	GameState.player_is_dead = true
	get_tree().paused = false
	get_tree().change_scene_to_file(GameState.get_spawn_room_path())


func _on_restart_button_pressed() -> void:
	_restart()


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
		if get_tree().paused and not is_player_dead:
			visible = false
			get_tree().paused = false
		else:
			show_game_menu("PAUSED", Color.WHITE, IS_RESUMEABLE)


func _on_options_button_pressed() -> void:
	game_menu_panel.visible = false
	options_panel.visible = true


func _on_back_button_pressed() -> void:
	game_menu_panel.visible = true
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
