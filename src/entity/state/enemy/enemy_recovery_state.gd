class_name EnemyRecoveryState
extends EnemyBaseState


func enter(entity: Enemy) -> void:
	entity.state_label.text = "EnemyRecoveryState"
	entity.play_anim("hurt")
	entity.recovery_timer = entity.RECOVERY_DURATION

func update(entity: Enemy, delta: float) -> void:
	entity.recovery_timer -= delta

	if entity.recovery_timer <= 0.0:
		if _player_in_range(entity, entity.ATTACK_RANGE):
			_go_to_enemy(entity, EnemyAttackState)
		elif _player_in_range(entity, entity.DETECTION_RANGE):
			_go_to_enemy(entity, EnemyPursuitState)
		else:
			_go_to_enemy(entity, EnemyIdleState)


func exit(entity: Enemy) -> void:
	entity.sprite.visible = true # safety reset
