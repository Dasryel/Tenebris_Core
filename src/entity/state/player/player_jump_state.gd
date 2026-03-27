class_name PlayerJumpState
extends PlayerBaseState


func enter(entity: Player) -> void:
    _perform_jump(entity)


func update(entity: Player, delta: float) -> void:
    var velocity := entity.velocity
    velocity.y += entity.gravity * delta

    # Tacky horizontal control during the jump's ascent
    var h_dir := Input.get_axis(GameInput.MOVE_LEFT, GameInput.MOVE_RIGHT)
    var target_velocity_x = h_dir * entity.speed

    velocity.x = move_toward(
        velocity.x,
        target_velocity_x,
        entity.air_acceleration * delta)

    entity.velocity = velocity
    entity.move_and_slide()

    # Listen for double jump input
    if Input.is_action_just_pressed(GameInput.JUMP):
        if entity.jump_count < entity.max_jumps:
            _perform_jump(entity)

    # Safety: landed during ascent (e.g. hit ceiling then immediately floor)
    if entity.is_on_floor():
        entity.reset_jump_count()
        _go_to_loco(entity, PlayerIdleState)
        return


func exit(_entity: Player) -> void:
    pass

func _perform_jump(entity: Player) -> void:
    entity.velocity.y = entity.jump_velocity
    entity.jump_count += 1

    # TODO: trigger jump animation
