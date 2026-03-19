extends Area2D

var player_ref: Node2D = null

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        player_ref = body
        player_ref.take_damage()
        $Timer.start()

func _on_body_exited(body: Node2D) -> void:
    if body is Player:
        player_ref = null
        $Timer.stop()

func _on_timer_timeout() -> void:
    if player_ref:
        player_ref.take_damage()
