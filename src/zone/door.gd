# door.gd
extends Area2D
class_name Door

@export_group("Navigation")

## The scene this door leads to
@export var target_scene: PackedScene

## The name of the Marker2D in the target scene where the player will appear
@export var entry_point_id: String = "Default"

@export_group("State")
## Unique ID to remember if THIS specific door was unlocked
@export var door_id: String
@export var is_locked: bool = true
@export var needs_key: bool = true

@export_group("Visuals")
@export var open_color: Color = Color.GREEN
@export var locked_color: Color = Color.RED
@onready var visual: ColorRect = $DoorVisual

var is_player_near: bool = false

func _ready() -> void:
	# If we previously unlocked this door, update the state
	if GameState.is_door_unlocked(door_id):
		is_locked = false

	update_visuals()

func _unhandled_input(event: InputEvent) -> void:
	if is_player_near and event.is_action_pressed("use"):
		_try_interact()

func _try_interact() -> void:
	if is_locked:
		if GameState.has_key:
			_unlock()
		else:
			SignalBus.display_message.emit("It's locked. I need a key.")
	else:
		_teleport()

func _unlock() -> void:
	is_locked = false

	GameState.unlock_door(door_id)
	GameState.has_key = false # Consume key

	update_visuals()

	SignalBus.display_message.emit("Unlocked!")
	SignalBus.door_unlocked.emit(door_id)

func _teleport() -> void:
	if target_scene:
		GameState.target_entry_point = entry_point_id
		get_tree().change_scene_to_packed(target_scene)

func update_visuals() -> void:
	if visual:
		visual.color = open_color if not is_locked else locked_color

func _on_body_entered(body: Node2D) -> void:
	# Assumes your player has 'class_name Player'
	if body is Player:
		is_player_near = true

		if not GameState.has_key:
			SignalBus.thought_bubble.emit("Door is locked. I should be looking for a key...")
			return

		var msg = "Press E to enter" if not is_locked else "Press E to enter"
		SignalBus.thought_bubble.emit(msg)
