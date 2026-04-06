class_name PlayerJumpState
extends PlayerBaseState


func enter(entity: Player) -> void:
	entity.jump_start_dir = sign(entity.velocity.x)
	_perform_jump(entity)

func update(entity: Player, delta: float) -> void:
	var velocity := entity.velocity

	# Add extra gravity for recovery jump
	if entity.is_recovery_jump:
		velocity.y += (entity.gravity + entity.recovery_jump_velocity) * delta
	else:
		velocity.y += entity.gravity * delta

	# Full horizontal control during the jump's ascent
	var h_dir := Input.get_axis(GameInput.MOVE_LEFT, GameInput.MOVE_RIGHT)

	if h_dir != 0.0 and sign(h_dir) != sign(entity.jump_start_dir) and entity.jump_start_dir != 0.0:
		velocity.x = h_dir * entity.speed * entity.opposing_jump_drag
	else:
		velocity.x = h_dir * entity.speed

	entity.velocity = velocity
	entity.move_and_slide()


	# Listen for double jump input
	if Input.is_action_just_pressed(GameInput.JUMP) and not entity.is_recovery_jump:
		if entity.jump_count < entity.max_jumps:
			_perform_jump(entity)

	# Safety: landed during ascent (e.g. hit ceiling then immediately floor)
	if entity.is_on_floor():
		entity.is_recovery_jump = false
		entity.reset_jump_count()
		_go_to_loco(entity, PlayerIdleState)
		return


func exit(_entity: Player) -> void:
	pass

func _perform_jump(entity: Player) -> void:
	if entity.is_recovery_jump:
		entity.velocity.y = entity.jump_velocity - entity.recovery_jump_velocity
	else:
		entity.velocity.y = entity.jump_velocity
		entity.jump_count += 1

	# TODO: trigger jump animation
