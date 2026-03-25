class_name EnemyBaseState
extends BaseState

func _player_in_range(entity: Enemy, rrange: float) -> bool:
    if Player.instance:
        return entity.global_position.distance_to(
            Player.instance.global_position
            ) <= rrange

    return false

func _face_target(entity: Enemy, target: Node2D) -> void:
    if target.global_position.x < entity.global_position.x:
        entity.sprite.flip_h = true
        entity.last_direction = Vector2.LEFT
    else:
        entity.sprite.flip_h = false
        entity.last_direction = Vector2.RIGHT

func on_notify(_entity: Enemy, _event: int) -> void:
    pass

## Shorthand: transition on the [b]Locomotion[/b] layer.
func _go_to_enemy(entity: Enemy, state_type: GDScript) -> void:
    _go_to(entity, Enemy.ENEMY_LAYER, state_type)
