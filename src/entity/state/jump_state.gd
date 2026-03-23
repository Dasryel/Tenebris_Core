class_name JumpState
extends BaseState


func enter(entity: Entity) -> void:
    if not entity.is_recovery_jump:
        _perform_jump(entity)


func update(entity: Entity, delta: float) -> void:
    var velocity := entity.velocity
    velocity.y += entity.gravity * delta

    # Full horizontal control during the jump's ascent
    var h_dir := Input.get_axis(GameInput.MOVE_LEFT, GameInput.MOVE_RIGHT)
    velocity.x = h_dir * entity.speed

    entity.velocity = velocity
    entity.move_and_slide()

    # Listen for double jump input
    if Input.is_action_just_pressed(GameInput.JUMP):
        if entity.jump_count < entity.max_jumps:
            _perform_jump(entity)

    # Apex reached → hand off to FallingState
    if entity.velocity.y > 0.0:
        _go_to_loco(entity, FallingState)
        return

    # Safety: landed during ascent (e.g. hit ceiling then immediately floor)
    if entity.is_on_floor():
        entity.reset_jump_count()
        _go_to_loco(entity, IdleState)
        return


func exit(_entity: Entity) -> void:
    pass

func _perform_jump(entity: Entity) -> void:
    entity.is_recovery_jump = false
    entity.velocity.y = entity.jump_velocity
    entity.jump_count += 1

    # TODO: trigger jump animation
