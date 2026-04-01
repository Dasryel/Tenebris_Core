class_name LavaEnemy
extends Enemy

@export var jump_height: float = 200.0
@export var jump_duration: float = 0.5
@export var jump_interval: float = 3.0

var _is_jumping: bool = false
var _original_y: float = 0.0


func _ready() -> void:
    _original_y = global_position.y
    _jump_loop()


func _jump_loop() -> void:
    while true:
        await get_tree().create_timer(jump_interval).timeout
        await _jump()


func _jump() -> void:
    if _is_jumping:
        return

    _is_jumping = true

    # Go up
    var tween := create_tween()
    tween.tween_property(self , "global_position:y", _original_y - jump_height, jump_duration) \
        .set_ease(Tween.EASE_OUT) \
        .set_trans(Tween.TRANS_SINE)
    await tween.finished

    # Come down
    tween = create_tween()
    tween.tween_property(self , "global_position:y", _original_y, jump_duration) \
        .set_ease(Tween.EASE_IN) \
        .set_trans(Tween.TRANS_SINE)
    await tween.finished

    _is_jumping = false


func _on_player_damage_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        body.take_damage(1, Vector2(0, 0))
        await self.get_tree().create_timer(0.75).timeout
