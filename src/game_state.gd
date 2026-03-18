extends Node

@warning_ignore("unused_signal")
signal key_pickedup
@warning_ignore("unused_signal")
signal hp_changed(current_hp, max_hp)
@warning_ignore("unused_signal")
signal player_died

var spawn_position: Vector2 = Vector2.ZERO
var has_key: bool = false
var max_hp: int = 3
var current_hp: int = 3

func reset() -> void:
	has_key = false
	current_hp = max_hp
	spawn_position = Vector2.ZERO
