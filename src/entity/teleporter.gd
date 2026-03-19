extends Area2D

## The scene this door leads to
@export_file("*.tscn") var target_scene: String
@export var entry_point_id: String = "Default"

var _is_teleporting: bool = false

func _on_body_entered(body: Node2D) -> void:
	if _is_teleporting or body is not Player:
		return

	_is_teleporting = true

	GameState.target_entry_point = entry_point_id
	set_deferred("monitoring", false)
	get_tree().call_deferred("change_scene_to_file", target_scene)
