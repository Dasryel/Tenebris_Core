class_name EnemyBaseState
extends BaseState

func _get_player() -> Player:
	return Player.instance

func _player_in_range(entity: Enemy, rrange: float) -> bool:
	if _get_player():
		return entity.global_position.distance_to(
			_get_player().global_position
			) <= rrange

	return false

func _face_target(entity: Enemy, target: Node2D) -> void:
	# print("posa: ", target.global_position.x, ", posb: ", entity.global_position.x)
	if target.global_position.x > entity.global_position.x:
		entity.sprite.flip_h = false
		entity.attack_hitbox.position.x = entity.attack_hitbox_offset
		entity.last_direction = Vector2.LEFT
	else:
		entity.sprite.flip_h = true
		entity.attack_hitbox.position.x = - entity.attack_hitbox_offset
		entity.last_direction = Vector2.RIGHT

func on_notify(entity: Enemy, event: int) -> void:
	# print(entity, event)
	if event == StateEvent.ENEMY_DAMAGED:
		_go_to_enemy(entity, EnemyRecoveryState)


## Shorthand: transition on the [b]Locomotion[/b] layer.
func _go_to_enemy(entity: Enemy, state_type: GDScript) -> void:
	_go_to(entity, Enemy.ENEMY_LAYER, state_type)
