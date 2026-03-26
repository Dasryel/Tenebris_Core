extends Node

@warning_ignore("unused_signal")
signal key_pickedup
@warning_ignore("unused_signal")
signal player_died
@warning_ignore("unused_signal")
signal door_unlocked
@warning_ignore("unused_signal")
signal dj_pickedup

var spawn_position: Vector2 = Vector2.ZERO
var has_key: bool = false
var has_dj: bool = false
var player_max_hp: int = 3
var player_current_hp: int = 3
var zone_text: String = ""

var unlocked_doors: Array[String] = []
# Player spawn Marker2D
var target_entry_point: String = ""

var current_player_zone: String = "undefined"
var current_player_room: String = "undefined"
var player_is_dead: bool = false

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

func is_door_unlocked(id: String) -> bool:
	return id in unlocked_doors

func unlock_door(id: String) -> void:
	if not is_door_unlocked(id):
		unlocked_doors.append(id)


func reset() -> void:
	has_key = false
	has_dj = false
	spawn_position = Vector2.ZERO
	player_current_hp = player_max_hp
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
