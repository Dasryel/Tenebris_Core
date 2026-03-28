extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        SignalBus.player_hp_changed.emit(GameState.player_current_hp + 1)
        self.queue_free()
