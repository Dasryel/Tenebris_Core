class_name ShadowFallingState
extends EnemyBaseState

func enter(_entity: Entity) -> void:
	# TODO: trigger falling animation
	pass


func update(entity: Entity, delta: float) -> void:
	# Apply gravity
	var velocity := entity.velocity
	velocity.y += entity.gravity * delta
	entity.velocity = velocity

	entity.move_and_slide()

	if entity.is_on_floor():
		entity.reset_jump_count()
		_go_to_enemy(entity, ShadowIdleState)
		return


func exit(_entity: Entity) -> void:
	pass
