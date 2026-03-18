extends Control

var current_timer: SceneTreeTimer
@export var bubble_timer: float = 3.0
@export var thought_bubble_text: Label

func _ready():
	visible = false
	SignalBus.thought_bubble.connect(show_message)

func show_message(text: String) -> void:
	thought_bubble_text.text = text
	visible = true

	# FIX: Cancel previous 'hide' logic if a new message comes in
	if current_timer:
		current_timer.timeout.disconnect(_on_timeout)

	current_timer = get_tree().create_timer(bubble_timer)
	current_timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	visible = false
	current_timer = null
