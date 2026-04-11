extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		SceneTransition.change_scene("res://scene/ui/main_menu.tscn", 2.0)


func _ready() -> void:
	pass
