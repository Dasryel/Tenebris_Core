class_name ShadowAttackState
extends EnemyBaseState

# const BaseState = preload("res://src/entity/state/enemy/enemy_base_state.gd")

func enter(entity: Entity) -> void:
	if entity.is_dead:
		return

	entity.state_label.text = "ShadowAttackState"
	entity.velocity = Vector2.ZERO

	var tree = entity.get_tree()
	await tree.create_timer(0.75).timeout

    # try to avoid race condition due to await timer
	if entity == null or entity.is_dead:
		return

	entity.play_anim("attack")

	# Listen for animation finish — connect once, auto-disconnect
	var callable = _on_animation_finished.bind(entity)

	if not entity.sprite.animation_finished.is_connected(callable):
		entity.sprite.animation_finished.connect(callable, CONNECT_ONE_SHOT)


func update(entity: Entity, _delta: float) -> void:
	# Hold position during attack — velocity already zeroed in enter()
	# Damage is handled by hitbox Area2D, not here
	if entity.is_dead:
		return


func _on_animation_finished(entity: Entity) -> void:
	# var tree = entity.get_tree()
	# await tree.create_timer(0.2).timeout
	_go_to_enemy(entity, ShadowIdleState)


# Safety: disconnect if state was interrupted (e.g. took damage)
func exit(entity: Entity) -> void:
	if entity.sprite.animation_finished.is_connected(_on_animation_finished):
		entity.sprite.animation_finished.disconnect(_on_animation_finished)
