# door.gd
extends Area2D
class_name Door

@export_group("Navigation")
## The scene this door leads to
@export_file("*.tscn") var target_scene: String
@export var zone_name: String = ""

@export var target_door_id: String = "Default"

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

func update_visuals() -> void:
	if visual:
		visual.color = open_color if not is_locked else locked_color

func _ready() -> void:
	# If we previously unlocked this door from the other end
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
			SignalBus.thought_bubble_show.emit("This door is locked...")
	else:
		_teleport()

func _unlock() -> void:
	is_locked = false

	GameState.unlock_door(door_id)
    # FIXME which key was actually used?
	SignalBus.key_used.emit("key1")

	update_visuals()

	SignalBus.thought_bubble_show.emit("Unlocked!")
	SignalBus.door_unlocked.emit(door_id)

func _teleport() -> void:
	GameState.target_entry_point = target_door_id
	GameState.zone_text = zone_name
	set_deferred("monitoring", false)
	get_tree().call_deferred("change_scene_to_file", target_scene)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_near = true

		var msg = "Press E to enter" if not is_locked else "Press E to unlock"
		SignalBus.thought_bubble_show.emit(msg)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_near = false
		SignalBus.thought_bubble_hide.emit()
