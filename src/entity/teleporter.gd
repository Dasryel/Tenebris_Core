extends Area2D

@export_file("*.tscn") var target_scene: String
@export var is_locked: bool = true
@export var needs_key: bool = true

var _is_active: bool = true
var _is_teleporting: bool = false
var _is_player_near: bool = false
var shader_mat := ShaderMaterial.new()

# Colors the sprite to orange or whatever the color is in shader file
func apply_locked_visuals() -> void:
	var mat := $Sprite2D.material as ShaderMaterial
	mat.set_shader_parameter("is_locked", is_locked)


func _ready() -> void:
	# Set or read the teleporter's locked status
	if not GameState.teleporters.has(name):
		GameState.teleporters[name] = is_locked
	else:
		is_locked = GameState.teleporters[name]

	if GameState.target_entry_point == self.name:
		_is_active = false
		get_tree().create_timer(0.1).timeout.connect(func(): _is_active = true)

	shader_mat.shader = load("res://resource/shader/teleporter_tint.gdshader")
	$Sprite2D.material = shader_mat
	apply_locked_visuals()


func _on_body_entered(body: Node2D) -> void:
	_is_player_near = true

	if is_locked:
		SignalBus.thought_bubble_show.emit("This portal is locked...")
		return

	if _is_teleporting or not _is_active or not body is Player:
		return

	_is_teleporting = true
	GameState.target_entry_point = self.name
	set_deferred("monitoring", false)
	get_tree().call_deferred("change_scene_to_file", target_scene)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("hiding bubble")
		_is_player_near = false
		SignalBus.thought_bubble_hide.emit()


func _unhandled_input(event: InputEvent) -> void:
	if _is_player_near and event.is_action_pressed("use"):
		_try_interact()


func _try_interact() -> void:
	if is_locked:
		if GameState.has_key:
			_unlock()
		else:
			SignalBus.thought_bubble_show.emit("You need a key to unlock this portal.")

func _unlock() -> void:
	is_locked = false
	GameState.teleporters[name] = false
	SignalBus.thought_bubble_show.emit("Unlocked!")
	apply_locked_visuals()
	# GameState.teleporter_unlocked.emit(name)
