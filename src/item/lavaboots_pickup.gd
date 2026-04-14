extends Area2D

	# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		if GameState.has_lava_boots:
			queue_free()
			print("lava boots pick up removed")
		


func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			GameState.has_lava_boots = true
			GameState.lavaboots_pickedup.emit()
			#$"../Lava/LavaBootsStaticBody2D".enable_lava_cover()
			queue_free()
