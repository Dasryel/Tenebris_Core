@tool
extends Marker2D

@export var label_text: String = "Spawn":
	set(value):
		label_text = value
		queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_string(ThemeDB.fallback_font, Vector2(-20, -15), label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.CHARTREUSE)
