class_name PlayerCamera
extends Camera2D

var player: Player

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("mwheel_up"):
        zoom += Vector2(0.1, 0.1)
    elif event.is_action_pressed("mwheel_down"):
        zoom -= Vector2(0.1, 0.1)

func _init(current_player: Player):
    player = current_player


func _ready() -> void:
    zoom = Vector2(3.5, 3.5)
    offset.y = -25.0
