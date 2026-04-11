@tool
extends Area2D

signal show_key
var key_id: String

@onready var editor_warning: Label = $EditorWarning
@export var key_type: KeyType = KeyType.NONE:
	set(value):
		key_type = value
		_update_editor_warning()
		update_configuration_warnings()

const KeyType = preload("res://src/item/key_type.gd").KeyType


func _process(_delta: float) -> void:
	# Disable key movement ine ditor
	if Engine.is_editor_hint():
		return

	position.y += sin(Time.get_ticks_msec() * 0.001) * 0.1


func _ready() -> void:
	key_id = GameState.get_key_id(key_type)
	if Engine.is_editor_hint():
		_update_editor_warning()
		return

	$EditorWarning.visible = false

	# Don't spawn if already picked up
	if GameState.picked_up_keys.has(key_id) and GameState.picked_up_keys[key_id].picked_up:
		queue_free()
		return

	# Register key if first time seen
	if not GameState.picked_up_keys.has(key_id):
		GameState.picked_up_keys[key_id] = GameState.KeyData.new()


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	print("[Key] picked up: ", key_id)
	SignalBus.key_picked_up.emit(key_id, key_type)
	queue_free()


func _update_editor_warning() -> void:
	if not is_node_ready():
		return
	if editor_warning == null:
		return
	if key_type == KeyType.NONE:
		editor_warning.visible = true
		editor_warning.text = "⚠ SET KEY TYPE ⚠"
	else:
		editor_warning.visible = false
