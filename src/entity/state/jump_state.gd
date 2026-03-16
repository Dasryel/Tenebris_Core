class_name JumpState
extends BaseState


func enter(entity: Entity) -> void:
	var velocity := entity.velocity
	velocity.y = entity.jump_velocity
	entity.velocity = velocity
	# TODO: trigger jump animation


func update(entity: Entity, delta: float) -> void:
	var velocity := entity.velocity
	velocity.y += entity.gravity * delta

	# Full horizontal control during the jump's ascent
	var h_dir := Input.get_axis(GameInput.MOVE_LEFT, GameInput.MOVE_RIGHT)
	velocity.x = h_dir * entity.speed

	entity.velocity = velocity
	entity.move_and_slide()

	# Apex reached → hand off to FallingState
	if entity.velocity.y > 0.0:
		_go_to_loco(entity, FallingState)
		return

	# Safety: landed during ascent (e.g. hit ceiling then immediately floor)
	if entity.is_on_floor():
		_go_to_loco(entity, IdleState)
		return


func exit(_entity: Entity) -> void:
	pass