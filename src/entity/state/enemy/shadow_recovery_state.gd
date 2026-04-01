class_name ShadowRecoveryState
extends EnemyBaseState


func enter(entity: Enemy) -> void:
	entity.state_label.text = "ShadowRecoveryState"
	entity.play_anim("hurt")
	entity.recovery_timer = entity.RECOVERY_DURATION

func update(entity: Enemy, delta: float) -> void:
	entity.recovery_timer -= delta

	if entity.recovery_timer <= 0.0:
		if _player_in_range(entity, entity.ATTACK_RANGE):
			_go_to_enemy(entity, ShadowAttackState)
		elif _player_in_range(entity, entity.DETECTION_RANGE):
			_go_to_enemy(entity, ShadowPursuitState)
		else:
			_go_to_enemy(entity, ShadowIdleState)


func exit(entity: Enemy) -> void:
	entity.sprite.visible = true # safety reset
