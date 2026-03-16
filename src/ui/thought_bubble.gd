extends Control

func _ready() -> void:
	visible = false

func show_message(text: String) -> void:
	$Panel/Label.text = text
	visible = true
	await get_tree().create_timer(5).timeout
	visible = false
