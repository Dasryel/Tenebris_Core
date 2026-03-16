## FIXME: Does not properly transition to FallingState when in the air.
class_name MoveState
extends BaseState


func enter(_entity: Entity) -> void:
	# TODO: change animation to moving
	pass


func update(entity: Entity, _delta: float) -> void:
	if Input.is_action_just_pressed(GameInput.JUMP):
		_go_to_loco(entity, JumpState)
		return

	var h_dir := Input.get_axis(GameInput.MOVE_LEFT, GameInput.MOVE_RIGHT)

	if is_zero_approx(h_dir):
		_go_to_loco(entity, IdleState)
		return

	var velocity := entity.velocity
	velocity.x = h_dir * entity.speed
	entity.velocity = velocity
	entity.move_and_slide()


func exit(_entity: Entity) -> void:
	pass