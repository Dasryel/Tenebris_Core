extends Area2D

@export_file("*.tscn") var target_scene: String

var _is_active: bool = true
var _is_teleporting: bool = false

func _ready() -> void:
    if GameState.target_entry_point == self.name:
        _is_active = false
        get_tree().create_timer(0.1).timeout.connect(func(): _is_active = true)

func _on_body_entered(body: Node2D) -> void:
    if _is_teleporting or not _is_active or not body is Player:
        return

    _is_teleporting = true
    GameState.target_entry_point = self.name
    set_deferred("monitoring", false)
    get_tree().call_deferred("change_scene_to_file", target_scene)
