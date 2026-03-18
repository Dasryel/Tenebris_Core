extends Area2D

var is_player_near := false
var target_scene = "res://scene/ui/end_screen.tscn"
@export var visual: ColorRect

func _unhandled_input(event: InputEvent) -> void:
	if is_player_near and event.is_action_pressed("open_door"):
		_try_open_door()

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return

	is_player_near = true
	visual.color = Color.GREEN

	if not GameState.has_key:
		SignalBus.thought_bubble.emit("Door is locked. I should be looking for a key...")
	else:
		SignalBus.thought_bubble.emit("Press E to enter")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_near = false
		visual.color = Color.GREEN

func _try_open_door() -> void:
	if GameState.has_key:
		GameState.has_key = false
		get_tree().change_scene_to_file(target_scene)
	else:
		SignalBus.thought_bubble.emit("I still need that key...")
