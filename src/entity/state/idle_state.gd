class_name IdleState
extends BaseState


func enter(entity: Entity) -> void:
	if not entity.is_on_floor():
		_go_to_loco(entity, FallingState)
		return

	entity.play_anim("idle")


func update(entity: Entity, _delta: float) -> void:
	if Input.is_action_just_pressed(GameInput.JUMP):
		_go_to_loco(entity, JumpState)
		return

	var direction := Input.get_vector(
		GameInput.MOVE_LEFT,
		GameInput.MOVE_RIGHT,
		GameInput.MOVE_UP,
		GameInput.MOVE_DOWN,
	)

	if direction != Vector2.ZERO:
		_go_to_loco(entity, MoveState)
		return


func exit(_entity: Entity) -> void:
	pass
