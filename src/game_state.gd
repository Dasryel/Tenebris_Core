extends Node

@warning_ignore("unused_signal")
signal key_pickedup
@warning_ignore("unused_signal")
signal player_died
@warning_ignore("unused_signal")
signal door_unlocked
@warning_ignore("unused_signal")
signal dj_pickedup
signal game_paused
signal moon_piece_collected(id)
signal moon_piece_used(id)

func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("debug_map"):
		get_tree().change_scene_to_file("res://scene/rooms/zone3/room1.tscn")


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

var moon_pieces: Dictionary = {
	"piece1": false,
	"piece2": false,
	"piece3": false,
}
var moon_pieces_used: Dictionary = {
	"piece1": false,
	"piece2": false,
	"piece3": false,
}
var moon_phase: int = 0

# sets game bg to black instead of gray
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0))

func is_door_unlocked(id: String) -> bool:
	return id in unlocked_doors

func unlock_door(id: String) -> void:
	if not is_door_unlocked(id):
		unlocked_doors.append(id)
		
func piece_pickedup(id: String):
	print("id received", id)
	moon_pieces[id] = true
	moon_piece_collected.emit(id)
	
func moon_pieces_count() -> int:
	var count = 0
	for piece in moon_pieces.values():
		if piece:
			count += 1
	return count


func reset() -> void:
	has_key = false
	#has_dj = false
	spawn_position = Vector2.ZERO
	player_current_hp = player_max_hp
	zone_text = ""
	#moon_phase = 0
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
	moon_pieces = {
	"piece1": false,
	"piece2": false,
	"piece3": false,
}
