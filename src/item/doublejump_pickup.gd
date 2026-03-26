extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.has_dj:
		queue_free()
		print("pick up removed")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.dj_pickedup.emit()
		SignalBus.extra_jump_pickup.emit()
		queue_free()
