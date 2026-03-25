class_name EnemyPursuitState
extends EnemyBaseState

const ATTACK_RANGE := 60.0
const ABANDON_RANGE := 350.0
const PURSUIT_SPEED := 80.0

# --- Pathfinding ---
# For a flying enemy, NavigationAgent2D gives you free obstacle avoidance.
# Add a NavigationAgent2D child to your Enemy scene named "NavigationAgent2D".
# Make sure your TileMap has a NavigationRegion or navigation polygons baked.

var _nav_agent: NavigationAgent2D


func enter(entity: Entity) -> void:
    entity.play_anim("run")
    # Grab the agent once — entity must have this child node
    _nav_agent = entity.get_node("NavigationAgent2D")
    _nav_agent.max_speed = PURSUIT_SPEED


func update(entity: Entity, delta: float) -> void:
    var player := _get_player(entity)
    if not player:
        _go_to(entity, EnemyIdleState)
        return

    var dist := entity.global_position.distance_to(player.global_position)

    # --- Transition checks ---
    if dist <= ATTACK_RANGE:
        _go_to(entity, EnemyAttackState)
        return

    if dist >= ABANDON_RANGE:
        _go_to(entity, EnemyIdleState)
        return

    # --- Navigation ---
    # Update destination every frame (or throttle with a timer for perf)
    _nav_agent.target_position = player.global_position

    var next_pos := _nav_agent.get_next_path_position()
    var direction := (next_pos - entity.global_position).normalized()

    _face_target(entity, player)

    # Flying = ignore gravity, direct velocity toward path point
    entity.velocity = direction * PURSUIT_SPEED
    entity.move_and_slide()


func exit(_entity: Entity) -> void:
    pass
