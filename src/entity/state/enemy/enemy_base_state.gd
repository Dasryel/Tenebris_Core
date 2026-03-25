class_name EnemyBaseState
extends BaseState


func _get_player(entity: Entity) -> Node2D:
    # Works with either a Player class or "Player" group
    return entity.get_tree().get_first_node_in_group("Player")

func _player_in_range(entity: Entity, rrange: float) -> bool:
    var player := _get_player(entity)
    if not player:
        return false
    return entity.global_position.distance_to(player.global_position) <= rrange

func _face_target(entity: Entity, target: Node2D) -> void:
    if target.global_position.x < entity.global_position.x:
        entity.sprite.flip_h = true
        entity.last_direction = Vector2.LEFT
    else:
        entity.sprite.flip_h = false
        entity.last_direction = Vector2.RIGHT

func on_notify(entity: Enemy, event: StateEvent) -> void:
    pass
