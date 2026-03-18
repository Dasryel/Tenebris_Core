extends Control

func _ready() -> void:
	visible = false

func show_message(text: String) -> void:
	$Panel/Label.text = text
	visible = true

func hide_message():
	visible = false
