extends Path2D

# This hack detects a player body in Area2d and moves the player
# while the platform moves. It was the only solution I could get
# to actually move the player.

@export var duration_seconds: float = 5.0
@export var wait_time_seconds: float = 1.0

@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var area_2d: Area2D = $PathFollow2D/MovingPlatform/Area2D

var _player_entity: CharacterBody2D
var _previous_position: Vector2


func _ready() -> void:
    _previous_position = path_follow.global_position
    area_2d.body_entered.connect(_on_body_entered)
    area_2d.body_exited.connect(_on_body_exited)
    _start_tween()


func _physics_process(_delta: float) -> void:
    var current_position := path_follow.global_position
    var movement_delta := current_position - _previous_position

    if _player_entity:
        _player_entity.global_position.x += movement_delta.x
        _player_entity.global_position.y += movement_delta.y

    _previous_position = current_position


func _set_progress(value: float) -> void:
    path_follow.progress_ratio = value


func _start_tween() -> void:
    var tween: Tween = create_tween().set_loops()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_method(_set_progress, 0.0, 1.0, duration_seconds)
    tween.tween_interval(wait_time_seconds)
    tween.tween_method(_set_progress, 1.0, 0.0, duration_seconds)
    tween.tween_interval(wait_time_seconds)


func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        _player_entity = body


func _on_body_exited(body: Node2D) -> void:
    if body.is_in_group("player"):
        _player_entity = null
