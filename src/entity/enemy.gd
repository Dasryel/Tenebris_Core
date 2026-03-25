class_name Enemy
extends Entity

const ENEMY_LAYER: StringName = &"Enemy"
var was_knocked_back: bool = false
var idle_timer: float = 0.0
var recovery_timer := 0.0
var flash_timer := 0.0
var is_flashing := false

func _init():
	hit_points = 2

func _ready() -> void:
	print("enemy initialized")
	last_direction = Vector2.RIGHT
	_add_state_machine(ENEMY_LAYER, StateCache.get_state(EnemyIdleState))

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
