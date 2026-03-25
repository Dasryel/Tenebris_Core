class_name EnemyAttackState
extends EnemyBaseState

# How long before enemy can attack again after recovery
const ATTACK_RANGE := 60.0

func enter(entity: Entity) -> void:
    entity.velocity = Vector2.ZERO

    if Player.instance:
        _face_target(entity, Player.instance)

    entity.play_anim("attack")

    # Listen for animation finish — connect once, auto-disconnect
    entity.animation_player.animation_finished.connect(
        _on_animation_finished.bind(entity),
        CONNECT_ONE_SHOT
    )


func update(_entity: Entity, _delta: float) -> void:
    # Hold position during attack — velocity already zeroed in enter()
    # Damage is handled by hitbox Area2D, not here
    pass


func _on_animation_finished(_anim_name: StringName, entity: Entity) -> void:
    _go_to(entity, Enemy.ENEMY_LAYER, EnemyRecoveryState)


func exit(entity: Entity) -> void:
    # Safety: disconnect if state was interrupted (e.g. took damage)
    if entity.animation_player.animation_finished.is_connected(_on_animation_finished):
        entity.animation_player.animation_finished.disconnect(_on_animation_finished)
