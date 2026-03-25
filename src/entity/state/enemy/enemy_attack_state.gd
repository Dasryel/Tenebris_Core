class_name EnemyAttackState
extends EnemyBaseState

func enter(entity: Entity) -> void:
	entity.state_label.text = "EnemyAttackState"
	entity.velocity = Vector2.ZERO

	#var player = _get_player()
	#if player:
	#	_face_target(entity, player)

	entity.play_anim("attack")

	# Listen for animation finish — connect once, auto-disconnect
	entity.sprite.animation_finished.connect(
		_on_animation_finished.bind(entity),
		CONNECT_ONE_SHOT
	)


func update(_entity: Entity, _delta: float) -> void:
	# Hold position during attack — velocity already zeroed in enter()
	# Damage is handled by hitbox Area2D, not here
	pass


func _on_animation_finished(entity: Entity) -> void:
	_go_to_enemy(entity, EnemyRecoveryState)


# Safety: disconnect if state was interrupted (e.g. took damage)
func exit(entity: Entity) -> void:
	if entity.sprite.animation_finished.is_connected(_on_animation_finished):
		entity.sprite.animation_finished.disconnect(_on_animation_finished)
