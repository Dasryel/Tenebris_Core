class_name ShadowEnemy
extends Enemy

var idle_timer: float = 0.0
var recovery_timer: float = 0.0

const EnemyDeathState = preload("res://src/entity/state/enemy/enemy_death_state.gd")

@export_group("Enemy params")
# TODO These should be defined in a resource, or as export vars
# So they could be customized earlier
@export var ATTACK_RANGE := 100.0 # How long before enemy can attack again after recovery
@export var ABANDON_RANGE := 600.0
@export var DETECTION_RANGE := 400.0
@export var PURSUIT_SPEED := 160.0
@export var RECOVERY_DURATION := 0.6 # seconds before enemy acts again
@export var FLASH_INTERVAL := 0.08 # seconds between visibility toggles
@export var IDLE_WAIT_MIN := 1.0
@export var IDLE_WAIT_MAX := 3.0

@export_group("Attack Hitbox")
@export var attack_hitbox: Area2D
@export var attack_hitbox_offset: float = 80.0
@export var attack_hitbox_collision: CollisionShape2D

var is_dead: bool = false

const ATTACK_DATA: Dictionary = {
	"attack": {
		"active_frames": [6],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "player_hurtbox",
	},
}

func _ready():
	SignalBus.debug_mode_toggled.connect(_on_debug_mode_toggled)
	_on_debug_mode_toggled()
	last_direction = Vector2.RIGHT
	_add_state_machine(ENEMY_LAYER, StateCache.get_state(ShadowIdleState))

	var sm = get_state_machine(ENEMY_LAYER)
	var current_state = sm.current_state
	current_state.enter(self )


func _on_debug_mode_toggled():
	print("toggling enemy state label")
	state_label.visible = GameState.debug_mode

# hopefully this really kills the monster
func _on_entity_death():
	is_dead = true
	var sm = get_state_machine(ENEMY_LAYER)
	sm.change_state(StateCache.get_state(EnemyDeathState), self )

	$CollisionShape2D.set_deferred("disabled", true)

func get_attack_data() -> Dictionary:
	return ATTACK_DATA

func get_attack_hitbox_collision() -> CollisionShape2D:
	return attack_hitbox_collision

func take_damage(amount: int, knockback_dir: Vector2) -> void:
	var sm = get_state_machine(ENEMY_LAYER)
	if sm.current_state is ShadowRecoveryState:
		return # already in recovery, ignore hit (or handle i-frames)

	hit_points -= amount

	if hit_points <= 0:
		print("enemy dies")
		_on_entity_death()
		return

	# Set knockback — RecoveryState will drain this
	var dir_x = sign(global_position.x - knockback_dir.x)
	velocity = Vector2(dir_x * 50.0, -100.0)

	sm.notify(self , StateEvent.ENEMY_DAMAGED)


func _on_player_damage_area_2d_body_entered(body: Node2D) -> void:
	print("player on top")
	if body.is_in_group("player"):
		body.take_damage(1, Vector2(0, 0))
		await self.get_tree().create_timer(0.75).timeout
