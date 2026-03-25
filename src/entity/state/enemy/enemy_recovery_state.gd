class_name EnemyRecoveryState
extends EnemyBaseState

const RECOVERY_DURATION := 0.6 # seconds before enemy acts again
const FLASH_INTERVAL := 0.08 # seconds between visibility toggles
const ATTACK_RANGE := 60.0
const DETECTION_RANGE := 200.0

var _recovery_timer := 0.0
var _flash_timer := 0.0
var _is_flashing := false


func enter(entity: Entity, is_hurt: bool = false) -> void:
    _recovery_timer = RECOVERY_DURATION
    _flash_timer = 0.0
    _is_flashing = is_hurt # only flash if this is a hurt-recovery

    # "hurt" anim if hit, otherwise just idle while recovering post-attack
    if is_hurt:
        entity.play_anim("hurt")
    else:
        entity.play_anim("idle")

    # Knockback velocity is already set by take_damage() on the entity
    # We just let move_and_slide() drain it naturally here


func update(entity: Entity, delta: float) -> void:
    _recovery_timer -= delta

    # --- Sprite flash ---
    if _is_flashing:
        _flash_timer -= delta
        if _flash_timer <= 0.0:
            _flash_timer = FLASH_INTERVAL
            entity.sprite.visible = not entity.sprite.visible

    # --- Drain knockback velocity (friction) ---
    entity.velocity.x = move_toward(entity.velocity.x, 0.0, 300.0 * delta)
    entity.velocity.y = move_toward(entity.velocity.y, 0.0, 300.0 * delta)
    entity.move_and_slide()

    # --- Transition out ---
    if _recovery_timer <= 0.0:
        entity.sprite.visible = true # ensure visible when done

        if _player_in_range(entity, ATTACK_RANGE):
            _go_to(entity, EnemyAttackState)
        elif _player_in_range(entity, DETECTION_RANGE):
            _go_to(entity, EnemyPursuitState)
        else:
            _go_to(entity, EnemyIdleState)


func exit(entity: Entity) -> void:
    entity.sprite.visible = true # safety reset
