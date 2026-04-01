class_name ShadowIdleState
extends EnemyBaseState

# stupid hack
const ShadowFallingState = preload("res://src/entity/state/enemy/shadow_falling_state.gd")

func enter(entity: Enemy) -> void:
	if not entity.is_on_floor():
		_go_to_enemy(entity, ShadowFallingState)
		return

	entity.state_label.text = "ShadowIdleState"
	entity.play_anim("idle")
	entity.velocity = Vector2.ZERO
	entity.idle_timer = randf_range(entity.IDLE_WAIT_MIN, entity.IDLE_WAIT_MAX)


func update(entity: Enemy, delta: float) -> void:
	# Detection always takes priority
	if _player_in_range(entity, entity.DETECTION_RANGE):
		_go_to_enemy(entity, ShadowPursuitState)
		return

	entity.idle_timer -= delta
	# Could transition to a patrol state here later
	#if entity.idle_timer <= 0:
	#    _go_to_enemy(entity, EnemyPatrolState)


func exit(_entity: Enemy) -> void:
	pass
