## FIXME: Does not properly transition to FallingState when in the air.
class_name MoveState
extends BaseState


func enter(entity: Entity) -> void:
	entity.play_anim("run")


func update(entity: Entity, delta: float) -> void:
	if entity.is_in_combat():
		print("move: cant move while attacking")
		return

	if not entity.is_on_floor():
		_go_to_loco(entity, FallingState)
		return

	if Input.is_action_just_pressed(GameInput.JUMP):
		_go_to_loco(entity, JumpState)
		return

	var h_dir := Input.get_axis(GameInput.MOVE_LEFT, GameInput.MOVE_RIGHT)
	if h_dir > 0:
		entity.last_direction = Vector2.LEFT
		entity.sprite.flip_h = false
	elif h_dir < 0:
		entity.last_direction = Vector2.RIGHT
		entity.sprite.flip_h = true

	if is_zero_approx(h_dir):
		_go_to_loco(entity, IdleState)
		return

	var velocity := entity.velocity

	velocity.y += entity.gravity * delta
	velocity.x = h_dir * entity.speed
	entity.velocity = velocity
	entity.move_and_slide()


func exit(entity: Entity) -> void:
	entity.play_anim("idle")