class_name Player
extends Entity

# debug labels
@export var loco_state_label: Label
@export var combat_state_label: Label

@export var attack_hitbox: Area2D
@export var attack_hitbox_offset: float = 80.0
@export var attack_hitbox_collision: CollisionShape2D

# visible player tooltip/info bubble
@export var thought_bubble: Label


const LOCOMOTION_LAYER: StringName = &"Locomotion"
const COMBAT_LAYER: StringName = &"Combat"

# A ridiculous hack to make gdscript PARSE THIS FILE
const CombatIdle = preload("res://src/entity/state/player/player_combat_idle_state.gd")

static var instance: Player

const ATTACK_DATA: Dictionary = {
	"slash1": {
		"active_frames": [4],
		"damage": 1,
		"knockback_force": 200.0,
	},
	"slash2": {
		"active_frames": [1],
		"damage": 2,
		"knockback_force": 350.0,
	},
}

func _ready() -> void:
	instance = self
	last_direction = Vector2.LEFT
	GameState.key_pickedup.connect(key_obtained)
	# GameState.has_key = true

	if GameState.spawn_position != Vector2.ZERO:
		global_position = GameState.spawn_position
		GameState.spawn_position = Vector2.ZERO

	# Add the upper-body combat layer alongside the inherited locomotion layer.
	# We assume 'CombatLayer', 'StateCache', and 'CombatIdleState' are
	# accessible (e.g., as constants, members, or Autoloads).
	_add_state_machine(COMBAT_LAYER, StateCache.get_state(PlayerCombatIdleState))
	_add_state_machine(LOCOMOTION_LAYER, StateCache.get_state(PlayerFallingState))

	$AnimatedSprite2D.animation_finished.connect(_on_player_sprite_finished)
# end _ready

func get_attack_data() -> Dictionary:
	return ATTACK_DATA

func get_attack_hitbox_collision() -> CollisionShape2D:
	return attack_hitbox_collision

func is_in_combat() -> bool:
	var sm = get_state_machine(COMBAT_LAYER)
	var current_state = sm.current_state

	if current_state is PlayerCombatSlashingState:
		return true

	return false

func is_loco_idling() -> bool:
	var sm = get_state_machine(LOCOMOTION_LAYER)
	var current_state = sm.current_state

	if current_state is PlayerIdleState:
		return true

	return false

func _process(delta: float) -> void:
	super (delta)
	_update_state_label(LOCOMOTION_LAYER, loco_state_label)
	_update_state_label(COMBAT_LAYER, combat_state_label)
# end _process

func _update_state_label(layer_name: StringName, label: Label) -> void:
	var sm = get_state_machine(layer_name)
	if not sm:
		return

	var current_state = sm.current_state
	if not current_state:
		label.text = "State: Initializing..."
		return

	label.text = "State: %s" % current_state.get_script().get_global_name()

func _on_player_sprite_finished() -> void:
	SignalBus.player_sprite_anim_finished.emit()


func _on_damage_taken(_current_hp: int) -> void:
	SignalBus.emit_signal("player_hp_changed", hit_points)

func _on_entity_death():
	GameState.player_died.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("heal"):
		heal(1)

	if event.is_action_pressed("damage"):
		take_damage(1, Vector2(0, 0))
# end _unhandled_input


func key_obtained() -> void:
	GameState.has_key = true
	print("player has key: ", GameState.has_key)


func _on_animated_sprite_2d_frame_changed() -> void:
	var anim = sprite.animation
	var frame = sprite.frame
	var is_active_frame = false

	if anim == "slash1":
		is_active_frame = (frame == 4)
	elif anim == "slash2":
		is_active_frame = (frame == 1)

	attack_hitbox_collision.set_deferred("disabled", !is_active_frame)


func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		var victim = area.get_parent()
		if victim.has_method("take_damage"):
			var knockback_dir = get_knockback_direction(
				self.global_position,
				victim.global_position
				)

			victim.take_damage(1, knockback_dir)
