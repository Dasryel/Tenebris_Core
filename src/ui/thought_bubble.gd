extends Control

@export var thought_bubble_text: Label

func _ready():
	visible = false
	SignalBus.thought_bubble_show.connect(_on_show_message)
	SignalBus.thought_bubble_hide.connect(_on_hide_message)

func _on_show_message(text: String) -> void:
	thought_bubble_text.text = text
	visible = true

func _on_hide_message() -> void:
	visible = false
