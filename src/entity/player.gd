class_name Player
extends Entity

@warning_ignore("unused_private_class_variable")
var _combat_anim_callable: Callable = Callable()
var _thougt_bubble_default_local_position: Vector2

@export_group("Labels")
@export var loco_state_label: Label
# visible player tooltip/info bubble
@export var thought_bubble_panel: Panel

@export_group("Attack hitboxes")
@export var attack_hitbox: Area2D
@export var attack_hitbox_offset: float = 80.0
@export var attack_hitbox_collision: CollisionShape2D

@export_group("Sound effects")
@export var jump_sound: AudioStream
@export var pickup_sound: AudioStream
@export var slash1_sound: AudioStream


const LOCOMOTION_LAYER: StringName = &"Locomotion"

static var instance: Player

# FIXME this is really stupid now with so many different animations, oh well
const ATTACK_DATA: Dictionary = {
	"slash1_god_left": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "enemy_hurtbox",
	},
	"slash1_god_right": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "enemy_hurtbox",
	},
	"slash1_norm_left": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "enemy_hurtbox",
	},
	"slash1_norm_right": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "enemy_hurtbox",
	},
	"slash2_god_left": {
		"active_frames": [1],
		"damage": 2,
		"knockback_force": 350.0,
		"target_group": "enemy_hurtbox",
	},
	 "slash2_god_right": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "enemy_hurtbox",
	},
	"slash2_norm_left": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "enemy_hurtbox",
	},
	"slash2_norm_right": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "enemy_hurtbox",
	},

}

func _ready() -> void:
	instance = self
	last_direction = Vector2.LEFT
	_thougt_bubble_default_local_position = thought_bubble_panel.position

	SignalBus.debug_mode_toggled.connect(_on_debug_mode_toggled)
	_on_debug_mode_toggled()

	SignalBus.extra_jump_pickup.connect(_on_extra_jump_pickup)
	if GameState.has_dj: max_jumps = 2

	if GameState.spawn_position != Vector2.ZERO:
		global_position = GameState.spawn_position
		GameState.spawn_position = Vector2.ZERO

	# Add the upper-body combat layer alongside the inherited locomotion layer.
	# We assume 'CombatLayer', 'StateCache', and 'CombatIdleState' are
	# accessible (e.g., as constants, members, or Autoloads).
	_add_state_machine(LOCOMOTION_LAYER, StateCache.get_state(PlayerFallingState))

	$AnimatedSprite2D.animation_finished.connect(_on_player_sprite_finished)

	if not OS.is_debug_build():
		loco_state_label.visible = false


# end _ready

func get_attack_data() -> Dictionary:
	return ATTACK_DATA

func get_attack_hitbox_collision() -> CollisionShape2D:
	return attack_hitbox_collision

func is_loco_idling() -> bool:
	var sm = get_state_machine(LOCOMOTION_LAYER)
	var current_state = sm.current_state

	if current_state is PlayerIdleState:
		return true

	return false

func is_taking_damage() -> bool:
	var sm = get_state_machine(LOCOMOTION_LAYER)
	var current_state = sm.current_state

	if current_state is PlayerHurtState:
		return true

	return false

func _get_anim_key(anim: String) -> String:
	var mode_str := "god" if GameState.has_dj else "norm"
	var dir_str := "right" if last_direction.x > 0 else "left"
	return "%s_%s_%s" % [anim, mode_str, dir_str]


func play_anim(anim: String) -> void:
	var key := _get_anim_key(anim)
	if sprite.sprite_frames.has_animation(key):
		sprite.play(key)
	else:
		push_warning("[Player] Animation not found: %s" % key)

func _process(delta: float) -> void:
	for sm in _state_machines.values():
		sm.update(self , delta)

	_update_state_label(LOCOMOTION_LAYER, loco_state_label)
	_update_thought_bubble_screen_position()
# end _process

func _update_thought_bubble_screen_position() -> void:
	if not thought_bubble_panel.visible:
		return

	var cam: Camera2D = get_viewport().get_camera_2d()
	if not cam:
		return

	var zoom: Vector2 = cam.zoom

	var viewport_size: Vector2 = get_viewport_rect().size
	var cam_center: Vector2 = cam.get_screen_center_position()

	var half_w: float = (viewport_size.x / zoom.x) / 2.0
	var half_h: float = (viewport_size.y / zoom.y) / 2.0
	var world_left: float = cam_center.x - half_w
	var world_right: float = cam_center.x + half_w
	var world_top: float = cam_center.y - half_h
	var world_bottom: float = cam_center.y + half_h

	var desired_world: Vector2 = to_global(_thougt_bubble_default_local_position)
	var panel_size_world: Vector2 = thought_bubble_panel.size / zoom

	var clamped_world: Vector2 = Vector2(
		clamp(desired_world.x, world_left, world_right - panel_size_world.x),
		clamp(desired_world.y, world_top, world_bottom - panel_size_world.y)
	)

	thought_bubble_panel.position = to_local(clamped_world)

func _update_state_label(layer_name: StringName, label: Label) -> void:
	var sm = get_state_machine(layer_name)
	if not sm:
		return

	var current_state = sm.current_state
	if not current_state:
		label.text = "State: Initializing..."
		return

	label.text = "State: %s" % current_state.get_script().get_global_name()

func _on_debug_mode_toggled():
	loco_state_label.visible = GameState.debug_mode

func _on_extra_jump_pickup():
	max_jumps += 1

func _on_player_sprite_finished() -> void:
	SignalBus.player_sprite_anim_finished.emit()


func _on_damage_taken(_current_hp: int) -> void:
	SignalBus.emit_signal("player_hp_changed", hit_points)

func _on_entity_death():
	set_process(false)
	for sm in _state_machines.values():
		sm.terminate()

	play_anim("die")
	await sprite.animation_finished
	GameState.player_died.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("heal"):
		heal(1)

	if event.is_action_pressed("damage"):
		take_damage(1, Vector2(0, 0))
# end _unhandled_input


func take_damage(amount: int, knockback_dir: Vector2) -> void:
	hit_points -= amount
	SignalBus.player_hp_changed.emit(hit_points)

	if hit_points <= 0:
		print("player dies")
		_on_entity_death()
		return

	# Set knockback — RecoveryState will drain this
	var dir_x = sign(global_position.x - knockback_dir.x)
	velocity = Vector2(dir_x * 50.0, -100.0)

	var sm = get_state_machine(LOCOMOTION_LAYER)
	sm.change_state(StateCache.get_state(PlayerHurtState), self )
