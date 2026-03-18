extends Area2D

@onready var visual = $DoorVisual

func _on_body_entered(body: Player) -> void:
	body.near_door = true # Set the flag on the player
	if not GameState.has_key:
		body.thought_bubble.show_message("Door is locked. I should be looking for a key...")
	else:
		visual.color = Color.GREEN
		body.thought_bubble.show_message("Press E to enter")

func _on_body_exited(body: Player) -> void:
	body.near_door = false
	visual.color = Color.RED
