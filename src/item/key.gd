@tool
extends Area2D

signal show_key
@onready var sprite = $Sprite2D
var shader_mat := ShaderMaterial.new()
var key_id: String

@onready var editor_warning: Label = $EditorWarning
@export var key_type: KeyType = KeyType.NONE:
	set(value):
		key_type = value
		key_id = _get_key_id(key_type)
		_update_tint()
		_update_editor_warning()
		update_configuration_warnings()

const KeyType = preload("res://src/item/key_type.gd").KeyType
const KeyColors = preload("res://src/item/key_color.gd")


func _ready() -> void:
	key_id = _get_key_id(key_type)

	if shader_mat.shader == null:
		shader_mat.shader = load("res://resource/shader/sprite_tint.gdshader")
	_update_tint()

	if Engine.is_editor_hint():
		_update_editor_warning()
		_update_tint()
		return

	$EditorWarning.visible = false

	# Don't spawn if already picked up
	if GameState.keys.has(key_id) and GameState.keys[key_id].picked_up:
		queue_free()
		return

	# Register key if first time seen
	if not GameState.keys.has(key_id):
		var tint = KeyColors.get_color(key_id)
		GameState.keys[key_id] = GameState.KeyData.new(false, false, tint)


func _process(_delta: float) -> void:
	# Disable key movement ine ditor
	if Engine.is_editor_hint():
		return

	position.y += sin(Time.get_ticks_msec() * 0.001) * 0.1


func _update_tint() -> void:
	if not is_node_ready():
		return

	var s = get_node_or_null("Sprite2D")
	if s == null:
		return

	shader_mat.set_shader_parameter("tint_color", KeyColors.get_color(key_id))
	s.material = shader_mat

	if Engine.is_editor_hint():
		s.queue_redraw()


func _get_key_id(type: KeyType) -> String:
	var key_name = KeyType.keys()[type].to_lower() + "_key"
	return key_name
	# KeyType.RED -> "red_key" automatically


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	print("[Key] picked up: ", key_id)

	SignalBus.show_text_on_player_ui.emit(
		"You picked up the %s key!" % key_id.capitalize()
		)
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
