class_name EnemyIdleState
extends EnemyBaseState

const DETECTION_RANGE := 600.0
const IDLE_WAIT_MIN := 1.0
const IDLE_WAIT_MAX := 3.0

func enter(entity: Enemy) -> void:
    entity.play_anim("idle")
    entity.velocity = Vector2.ZERO
    entity.idle_timer = randf_range(IDLE_WAIT_MIN, IDLE_WAIT_MAX)


func update(entity: Enemy, delta: float) -> void:
    # Detection always takes priority
    if _player_in_range(entity, DETECTION_RANGE):
        _go_to_enemy(entity, EnemyPursuitState)
        return

    var _wait_timer = 0.0 - delta
    # Could transition to a patrol state here later
    # if _wait_timer <= 0: _go_to(entity, EnemyPatrolState)


func exit(_entity: Enemy) -> void:
    pass
