extends Node

var _canvas_layer: CanvasLayer
var _overlay: ColorRect

func setup_canvas_layer():
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 128
	get_tree().root.add_child(_canvas_layer)

func setup_overlay():
	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_canvas_layer.add_child(_overlay)

func change_scene(path: String, duration: float = 2.0) -> void:
	if _canvas_layer:
		return

	setup_canvas_layer()
	setup_overlay()

	# Fade OUT
	var tween = create_tween()
	tween.tween_property(_overlay, "color:a", 1.0, duration)
	await tween.finished

	get_tree().change_scene_to_file(path)
	await get_tree().process_frame

	# Fade IN
	tween = create_tween()
	tween.tween_property(_overlay, "color:a", 0.0, duration)
	await tween.finished

	_canvas_layer.queue_free()
	_canvas_layer = null
	_overlay = null
