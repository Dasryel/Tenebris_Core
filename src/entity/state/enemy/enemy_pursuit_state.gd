class_name EnemyPursuitState
extends EnemyBaseState

func enter(entity: Entity) -> void:
	entity.state_label.text = "EnemyPursuitState"
	entity.play_anim("run")

func update(entity: Entity, _delta: float) -> void:
	var player = _get_player()

	if not player:
		_go_to_enemy(entity, EnemyIdleState)
		return

	var dist := entity.global_position.distance_to(player.global_position)

	_face_target(entity, player)

	# --- Transition checks ---
	if dist <= entity.ATTACK_RANGE:
		_go_to_enemy(entity, EnemyAttackState)
		return

	if dist >= entity.ABANDON_RANGE:
		_go_to_enemy(entity, EnemyIdleState)
		return

	# Flying = ignore gravity, direct velocity toward path point
	entity.velocity = _new_heading(player, entity) * entity.PURSUIT_SPEED
	entity.move_and_slide()
# END update

func _new_heading(player: Entity, entity: Entity) -> Vector2:
	entity.rotator.look_at(player.global_position)
	# Calculate direct direction to player
	var direction = entity.global_position.direction_to(player.global_position)
	# could rotate the whole guy here
	# entity.rotation = direction.angle()

	if entity.ray_front.is_colliding():
		if not entity.ray_left.is_colliding():
			# Rotate the current direction vector 45 degrees left
			direction = direction.rotated(deg_to_rad(-45))
		elif not entity.ray_right.is_colliding():
			# Rotate the current direction vector 45 degrees right
			direction = direction.rotated(deg_to_rad(45))

	# Basic obstacle avoidance using RayCast2D nodes on the entity
	# Assumes entity has RayCast2D children named ray_left and ray_right
	if entity.ray_front.is_colliding():
		if not entity.ray_left.is_colliding():
			direction += entity.transform.x.orthogonal()
		elif not entity.ray_right.is_colliding():
			direction -= entity.transform.x.orthogonal()

	return direction
# END _new_heading


func exit(_entity: Entity) -> void:
	pass
