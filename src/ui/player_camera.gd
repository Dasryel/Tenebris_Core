class_name PlayerCamera
extends Camera2D

var player: Player

func _init(current_player: Player):
    player = current_player


func _ready() -> void:
    zoom = Vector2(3.5, 3.5)
    offset.y = -25.0
