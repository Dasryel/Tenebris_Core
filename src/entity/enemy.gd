class_name Enemy
extends Entity

@export var state_label: Label

# TODO These should be defined in a resource, or as export vars
# So they could be customized earlier
const ATTACK_RANGE := 100.0 # How long before enemy can attack again after recovery
const ABANDON_RANGE := 600.0
const DETECTION_RANGE := 400.0
const PURSUIT_SPEED := 160.0
const RECOVERY_DURATION := 0.6 # seconds before enemy acts again
const FLASH_INTERVAL := 0.08 # seconds between visibility toggles
const IDLE_WAIT_MIN := 1.0
const IDLE_WAIT_MAX := 3.0

const ENEMY_LAYER: StringName = &"Enemy"

var was_knocked_back: bool = false
var idle_timer: float = 0.0
var recovery_timer := 0.0
var flash_timer := 0.0
var is_flashing := false

@export_group("Navigation Rays")
@export var rotator: Node2D
@export var ray_front: RayCast2D
@export var ray_left: RayCast2D
@export var ray_right: RayCast2D

func _init():
	hit_points = 2

func _ready() -> void:
	last_direction = Vector2.RIGHT
	_add_state_machine(ENEMY_LAYER, StateCache.get_state(EnemyIdleState))

	var sm = get_state_machine(ENEMY_LAYER)
	var current_state = sm.current_state
	current_state.enter(self )

func take_damage(amount: int, knockback_dir: Vector2) -> void:
	var sm = get_state_machine(ENEMY_LAYER)
	if sm.current_state is EnemyRecoveryState:
		return # already in recovery, ignore hit (or handle i-frames)

	hit_points -= amount
	if hit_points <= 0:
		die()
		return

	# Set knockback — RecoveryState will drain this
	velocity = knockback_dir * knockback_force
	# Flag so RecoveryState knows to flash
	was_knocked_back = true
	sm.notify(self , StateEvent.ENEMY_DAMAGED)
