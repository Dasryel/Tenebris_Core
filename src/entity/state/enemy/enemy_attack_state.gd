class_name EnemyAttackState
extends EnemyBaseState

# How long before enemy can attack again after recovery
const ATTACK_RANGE := 60.0

var _attack_done := false

func enter(entity: Entity) -> void:
    _attack_done = false
    entity.velocity = Vector2.ZERO

    var player := _get_player(entity)
    if player:
        _face_target(entity, player)

    entity.play_anim("attack")

    # Listen for animation finish — connect once, auto-disconnect
    entity.animation_player.animation_finished.connect(
        _on_animation_finished.bind(entity),
        CONNECT_ONE_SHOT
    )


func update(entity: Entity, _delta: float) -> void:
    # Hold position during attack — velocity already zeroed in enter()
    # Damage is handled by hitbox Area2D, not here
    pass


func _on_animation_finished(_anim_name: StringName, entity: Entity) -> void:
    _attack_done = true
    _go_to(entity, EnemyRecoveryState)


func exit(_entity: Entity) -> void:
    # Safety: disconnect if state was interrupted (e.g. took damage)
    if entity.animation_player.animation_finished.is_connected(_on_animation_finished):
        entity.animation_player.animation_finished.disconnect(_on_animation_finished)
