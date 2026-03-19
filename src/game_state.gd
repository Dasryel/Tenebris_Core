extends Node

signal key_pickedup
signal hp_changed(current_hp, max_hp)
signal player_died
signal door_unlocked

var spawn_position: Vector2 = Vector2.ZERO
var hasKey: bool = false
var max_hp: int = 3
var current_hp: int = 3
var zone_text: String = ""

var doors: Dictionary = {
	"door1": false,
	"door2": false,
	"door3": false,
	"door4": false,
}

var keys: Dictionary = {
	"key1": false,
	"key2": false,
	"key3": false,
}


func reset() -> void:
	hasKey = false
	current_hp = max_hp
	spawn_position = Vector2.ZERO
	zone_text = ""
	doors = {
		"door1": false,
		"door2": false,
		"door3": false,
		"door4": false,
	}
	keys = {
		"key1": false,
		"key2": false,
		"key3": false,
	}
