class_name FallingState
extends BaseState

const AIR_CONTROL_MULTIPLIER: float = 0.2


func enter(_entity: Entity) -> void:
	# TODO: trigger falling animation
	pass


func update(entity: Entity, delta: float) -> void:
	# Apply gravity
	var velocity := entity.velocity
	velocity.y += entity.gravity * delta
	entity.velocity = velocity

	# Limited horizontal air control
	var direction := Input.get_vector(
		GameInput.MOVE_LEFT,
		GameInput.MOVE_RIGHT,
		GameInput.MOVE_UP,
		GameInput.MOVE_DOWN,
	)

	var target_x := direction.x * entity.speed * AIR_CONTROL_MULTIPLIER
	entity.velocity = Vector2(
		move_toward(entity.velocity.x, target_x, entity.speed * delta),
		entity.velocity.y,
	)

	entity.move_and_slide()

	if entity.is_on_floor():
		_go_to_loco(entity, IdleState)
		return


func exit(_entity: Entity) -> void:
	pass