class_name ShadowPursuitState
extends EnemyBaseState

# stupid hack
# const ShadowFallingState = preload("res://src/entity/state/enemy/shadow_falling_state.gd")

func enter(entity: Entity) -> void:
	entity.state_label.text = "ShadowPursuitState"
	entity.play_anim("run")

func update(entity: Entity, _delta: float) -> void:
	if not entity.is_on_floor():
		_go_to_enemy(entity, ShadowFallingState)
		return

	var player = _get_player()

	if not player:
		_go_to_enemy(entity, ShadowIdleState)
		return

	var dist := entity.global_position.distance_to(player.global_position)

	_face_target(entity, player)

	# --- Transition checks ---
	if dist <= entity.ATTACK_RANGE:
		_go_to_enemy(entity, ShadowAttackState)
		return

	if dist >= entity.ABANDON_RANGE:
		_go_to_enemy(entity, ShadowIdleState)
		return

	# Flying = ignore gravity, direct velocity toward path point
	entity.velocity = _new_heading(player, entity) * entity.PURSUIT_SPEED
	entity.move_and_slide()
# END update

func _new_heading(player: Entity, entity: Entity) -> Vector2:
	# Calculate direct direction to player
	var direction = entity.global_position.direction_to(player.global_position)
	return direction


func exit(_entity: Entity) -> void:
	pass
