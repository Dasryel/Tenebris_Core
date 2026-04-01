class_name LavaEnemy
extends Enemy

@export_group("Jump parameters")
@export var jump_height: float = 200.0
@export var jump_duration: float = 0.5
@export var jump_interval: float = 3.0

var _is_jumping: bool = false
var _original_y: float = 0.0


func _ready() -> void:
    _original_y = global_position.y
    sprite.play("idle")
    _jump_loop()


func _jump_loop() -> void:
    while true:
        await get_tree().create_timer(jump_interval).timeout
        _jump()


func _jump() -> void:
    if _is_jumping:
        return

    _is_jumping = true
    sprite.play("jump")

    # Up & down
    await _tween_lava_enemy(_original_y - jump_height, Tween.EASE_OUT)
    await _tween_lava_enemy(_original_y, Tween.EASE_IN)

    sprite.play("idle")
    _is_jumping = false


func _tween_lava_enemy(height: float, eease: Tween.EaseType):
    var tween = create_tween()
    tween.tween_property(self , "global_position:y", height, jump_duration) \
        .set_ease(eease) \
        .set_trans(Tween.TRANS_SINE)
    await tween.finished


func _on_entity_death() -> void:
    sprite.play("die")
    set_process(false)
    set_physics_process(false)
    # Wait for the death animation to finish before removing
    await sprite.animation_finished
    queue_free()


func _on_player_damage_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        body.take_damage(1, Vector2(0, 0))
        await get_tree().create_timer(0.75).timeout
