class_name EnemyIdleState
extends EnemyBaseState

func enter(entity: Enemy) -> void:
    entity.state_label.text = "EnemyIdleState"
    entity.play_anim("idle")
    entity.velocity = Vector2.ZERO
    entity.idle_timer = randf_range(entity.IDLE_WAIT_MIN, entity.IDLE_WAIT_MAX)


func update(entity: Enemy, delta: float) -> void:
    # Detection always takes priority
    if _player_in_range(entity, entity.DETECTION_RANGE):
        _go_to_enemy(entity, EnemyPursuitState)
        return

    entity.idle_timer -= delta
    # Could transition to a patrol state here later
    #if entity.idle_timer <= 0:
    #    _go_to_enemy(entity, EnemyPatrolState)


func exit(_entity: Enemy) -> void:
    pass
