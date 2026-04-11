@tool
extends Area2D

const KeyType = preload("res://src/item/key_type.gd").KeyType
const KeyColors = preload("res://src/item/key_color.gd")

@export_file("*.tscn") var target_scene: String
@export var is_locked: bool = true
var key_id: String

@export var needs_key: bool = true:
	set(value):
		needs_key = value
		_update_visuals()
		_update_editor_warning()
		update_configuration_warnings()

@export var key_type: KeyType = KeyType.NONE:
	set(value):
		key_type = value
		key_id = _get_key_id(key_type)
		_update_visuals()
		_update_editor_warning()
		update_configuration_warnings()

@onready var editor_warning: Label = $EditorWarning

var _is_active: bool = true
var _is_teleporting: bool = false
var _is_player_near: bool = false
var shader_mat := ShaderMaterial.new()


func _ready() -> void:
	key_id = _get_key_id(key_type)
	shader_mat.shader = load("res://resource/shader/sprite_tint.gdshader")
	$Sprite2D.material = shader_mat
	_update_visuals()

	if Engine.is_editor_hint():
		_update_editor_warning()
		return

	# Runtime-only setup
	if not GameState.teleporters.has(name):
		GameState.teleporters[name] = is_locked
	else:
		is_locked = GameState.teleporters[name]
	if GameState.target_entry_point == self.name:
		_is_active = false
		get_tree().create_timer(0.1).timeout.connect(func(): _is_active = true)


func _update_visuals() -> void:
	if not is_node_ready(): return

	var sprite = get_node_or_null("Sprite2D")
	if sprite == null: return

	if shader_mat.shader == null:
		shader_mat.shader = load("res://resource/shader/sprite_tint.gdshader")

	sprite.material = shader_mat
	shader_mat.set_shader_parameter("is_tinted", is_locked)

	if is_locked and needs_key:
		shader_mat.set_shader_parameter("tint_color", KeyColors.get_color(key_id))
	if Engine.is_editor_hint():
		sprite.queue_redraw()


func _get_key_id(type: KeyType) -> String:
	var key_name = KeyType.keys()[type].to_lower() + "_key"
	return key_name
	# KeyType.RED -> "red_key" automatically


func _on_body_entered(body: Node2D) -> void:
	_is_player_near = true

	if is_locked:
		SignalBus.thought_bubble_show.emit("This portal is locked...")
		return

	if _is_teleporting or not _is_active or not body is Player:
		return

	_teleport()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("hiding bubble")
		_is_player_near = false
		SignalBus.thought_bubble_hide.emit()


func _unhandled_input(event: InputEvent) -> void:
	if _is_player_near and event.is_action_pressed("use"):
		_try_interact()


func _teleport():
	_is_teleporting = true
	GameState.target_entry_point = self.name
	set_deferred("monitoring", false)
	get_tree().call_deferred("change_scene_to_file", target_scene)


func _try_interact() -> void:
	if is_locked:
		if GameState.player_has_key(key_type):
			_unlock()
		else:
			SignalBus.thought_bubble_show.emit("You need a correct key to unlock this portal.")
	else:
		_teleport()


func _unlock() -> void:
	is_locked = false
	GameState.teleporters[name] = false

	# FIXME should really figure out what the key string is and use the correct key
	# instead of this hardcoded "key1"
	SignalBus.key_used.emit(key_id, key_type)
	SignalBus.thought_bubble_show.emit("Unlocked!")

	_update_visuals()
	# GameState.teleporter_unlocked.emit(name)


func _update_editor_warning() -> void:
	if not is_node_ready():
		return
	if editor_warning == null:
		return

	# needs_key=false means warning is NEVER needed, regardless of key_type
	var should_warn: bool = needs_key and key_type == KeyType.NONE
	editor_warning.visible = should_warn
	editor_warning.text = "⚠ SET KEY TYPE ⚠" if should_warn else ""
