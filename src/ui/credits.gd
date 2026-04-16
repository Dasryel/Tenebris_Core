extends Control

@onready var credits = $VBoxContainer

var scroll_speed := 40


func _process(delta):
	credits.position.y -= scroll_speed * delta

	# when credits finish scrolling
	if credits.position.y < -credits.size.y or Input.is_action_pressed("escape"):
		SceneTransition.change_scene("res://scene/ui/main_menu.tscn")
