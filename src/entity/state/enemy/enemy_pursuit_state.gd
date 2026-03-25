class_name EnemyPursuitState
extends EnemyBaseState

# --- Pathfinding ---
# For a flying enemy, NavigationAgent2D gives you free obstacle avoidance.
# Add a NavigationAgent2D child to your Enemy scene named "NavigationAgent2D".
# Make sure your TileMap has a NavigationRegion or navigation polygons baked.

func enter(entity: Entity) -> void:
	entity.state_label.text = "EnemyPursuitState"
	entity.play_anim("run")
	# Grab the agent once — entity must have this child node
	entity.nav_agent.max_speed = entity.PURSUIT_SPEED


func update(entity: Entity, _delta: float) -> void:
	var player = _get_player()

	if not player:
		_go_to_enemy(entity, EnemyIdleState)
		return

	var dist := entity.global_position.distance_to(player.global_position)

	# --- Transition checks ---
	if dist <= entity.ATTACK_RANGE:
		_go_to_enemy(entity, EnemyAttackState)
		return

	if dist >= entity.ABANDON_RANGE:
		_go_to_enemy(entity, EnemyIdleState)
		return

	# --- Navigation ---
	# Update destination every frame (or throttle with a timer for perf)
	entity.nav_agent.target_position = player.global_position

	var next_pos = entity.nav_agent.get_next_path_position()
	var direction = (next_pos - entity.global_position).normalized()

	_face_target(entity, player)

	# Flying = ignore gravity, direct velocity toward path point
	entity.velocity = direction * entity.PURSUIT_SPEED
	entity.move_and_slide()


func exit(_entity: Entity) -> void:
	pass
