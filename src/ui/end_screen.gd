extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") or event.is_action_pressed("use") or event.is_action_pressed("fire"):
		SceneTransition.change_scene("res://scene/ui/result_screen.tscn", 2.0)


func _ready() -> void:
	pass
