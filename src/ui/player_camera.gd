class_name PlayerCamera
extends Camera2D


func _ready() -> void:
	SignalBus.camera_bounds_changed.connect(_on_camera_bounds_changed)
	# zoom = Vector2(3.5, 3.5)
	# offset.y = -25.0

	limit_enabled = true
	limit_smoothed = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mwheel_up"):
		zoom += Vector2(0.1, 0.1)
	elif event.is_action_pressed("mwheel_down"):
		zoom -= Vector2(0.1, 0.1)

func _on_camera_bounds_changed(top_left: Vector2, bottom_right: Vector2):
	limit_left = int(top_left.x)
	limit_top = int(top_left.y)
	limit_right = int(bottom_right.x)
	limit_bottom = int(bottom_right.y)
