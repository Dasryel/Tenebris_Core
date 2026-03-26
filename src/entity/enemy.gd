class_name Enemy
extends Entity

@export var state_label: Label

const ENEMY_LAYER: StringName = &"Enemy"

var idle_timer: float = 0.0
var recovery_timer: float = 0.0

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

@export_group("Navigation Rays")
@export var rotator: Node2D
@export var ray_front: RayCast2D
@export var ray_left: RayCast2D
@export var ray_right: RayCast2D

@export_group("Attack Hitbox")
@export var attack_hitbox: Area2D
@export var attack_hitbox_offset: float = 80.0
@export var attack_hitbox_collision: CollisionShape2D

const ATTACK_DATA: Dictionary = {
	"attack": {
		"active_frames": [6],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "player_hurtbox",
	},
}

func _init():
	hit_points = 2

func _ready() -> void:
	last_direction = Vector2.RIGHT
	_add_state_machine(ENEMY_LAYER, StateCache.get_state(EnemyIdleState))

	var sm = get_state_machine(ENEMY_LAYER)
	var current_state = sm.current_state
	current_state.enter(self )

func get_attack_data() -> Dictionary:
	return ATTACK_DATA

func get_attack_hitbox_collision() -> CollisionShape2D:
	return attack_hitbox_collision

func take_damage(amount: int, knockback_dir: Vector2) -> void:
	var sm = get_state_machine(ENEMY_LAYER)
	if sm.current_state is EnemyRecoveryState:
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
