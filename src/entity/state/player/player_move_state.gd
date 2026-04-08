class_name PlayerMoveState
extends PlayerBaseState


func enter(entity: Entity) -> void:
	entity.play_anim("run")


func update(entity: Player, delta: float) -> void:
	if entity.is_in_combat():
		print("move: cant move while attacking")
		return

	if not entity.is_on_floor():
		_go_to_loco(entity, PlayerFallingState)
		return

	if Input.is_action_just_pressed(GameInput.JUMP):
		_go_to_loco(entity, PlayerJumpState)
		return

	var h_dir := Input.get_axis(GameInput.MOVE_LEFT, GameInput.MOVE_RIGHT)
	_update_orientation(entity, h_dir)

	if is_zero_approx(h_dir):
		_go_to_loco(entity, PlayerIdleState)
		return

	var velocity := entity.velocity

	velocity.y += entity.gravity * delta
	velocity.x = h_dir * entity.speed
	entity.velocity = velocity
	entity.move_and_slide()


func exit(entity: Entity) -> void:
	entity.play_anim("idle")

func _update_orientation(entity: Player, h_dir: float) -> void:
	if h_dir > 0:
		entity.last_direction = Vector2.LEFT
		entity.attack_hitbox.position.x = entity.attack_hitbox_offset
	elif h_dir < 0:
		entity.last_direction = Vector2.RIGHT
		entity.attack_hitbox.position.x = - entity.attack_hitbox_offset
