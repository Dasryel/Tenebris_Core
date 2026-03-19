extends Area2D

## The scene this door leads to
@export_file("*.tscn") var target_scene: String
@export var entry_point_id: String = "Default"

func _on_body_entered(body: Node2D) -> void:
    print("player entering teleporter, target" + entry_point_id)
    if body is Player:
        GameState.target_entry_point = entry_point_id
        get_tree().change_scene_to_file(target_scene)
