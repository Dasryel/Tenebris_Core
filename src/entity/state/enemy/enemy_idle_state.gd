class_name EnemyIdleState
extends EnemyBaseState

const DETECTION_RANGE := 200.0
const IDLE_WAIT_MIN := 1.0
const IDLE_WAIT_MAX := 3.0

var _wait_timer := 0.0

func enter(entity: Entity) -> void:
    entity.play_anim("idle")
    entity.velocity = Vector2.ZERO
    _wait_timer = randf_range(IDLE_WAIT_MIN, IDLE_WAIT_MAX)


func update(entity: Entity, delta: float) -> void:
    # Detection always takes priority
    if _player_in_range(entity, DETECTION_RANGE):
        _go_to(entity, EnemyPursuitState)
        return

    _wait_timer -= delta
    # Could transition to a patrol state here later
    # if _wait_timer <= 0: _go_to(entity, EnemyPatrolState)


func exit(_entity: Entity) -> void:
    pass
