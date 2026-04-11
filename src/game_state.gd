extends Node

signal key_pickedup
signal player_died
signal dj_pickedup
signal game_paused
signal moon_piece_collected(id)
signal moon_piece_used(id)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_map"):
		get_tree().change_scene_to_file("res://scene/rooms/zone3/room1.tscn")

	if event.is_action_pressed("toggle_debug"):
		print("debug mode toggled")
		debug_mode = !debug_mode
		SignalBus.debug_mode_toggled.emit()

# Really need to add more default rooms if we add more zones
const ZONE_SPAWN_ROOMS: Dictionary = {
	"zone1": "spawn_room.tscn",
	"zone2": "lava_hall.tscn",
}

class KeyData:
	var picked_up: bool = false
	var used: bool = false
	var tint: Color = Color(1.0, 1.0, 1.0, 1.0)

	func _init(
		p: bool = false,
		u: bool = false,
		t: Color = Color(1.0, 0.0, 0.0, 1.0)
	):
		picked_up = p
		used = u
		tint = t

var debug_mode: bool = false
var spawn_position: Vector2 = Vector2.ZERO
var target_entry_point: String = ""
var zone_text: String = ""
var current_player_zone: String = "undefined"
var current_player_room: String = "undefined"

var has_dj: bool = true

var player_max_hp: int = 3
var player_current_hp: int = 3

# K: string name, V: bool unlocked false, locked true
var teleporters: Dictionary = {}
var unlocked_doors: Array[String] = []
var player_is_dead: bool = false

var keys: Dictionary = {}

var doors: Dictionary = {
	"door1": false,
	"door2": false,
	"door3": false,
	"door4": false,
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

var game_logger = GameLogger.new()
const GameLogger = preload("res://src/core/game_logger.gd")
const KeyType = preload("res://src/item/key_type.gd").KeyType

# sets game bg to black instead of gray
func _ready() -> void:
	OS.add_logger(game_logger)
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	SignalBus.key_picked_up.connect(_on_key_picked_up)
	SignalBus.key_used.connect(_on_key_used)

func _on_key_picked_up(key_id: String, _key_type: KeyType) -> void:
	keys[key_id].picked_up = true

func _on_key_used(key_id: String, _key_type: KeyType) -> void:
	keys[key_id].used = true

func _process(_delta: float) -> void:
	game_logger.flush()

func get_unused_keys() -> Array:
	return keys.keys().filter(
		func(key_id):
			return keys[key_id].picked_up and keys[key_id].used == false
	)

func player_has_key(key_type: KeyType) -> bool:
	var entry = keys.get(get_key_id(key_type))
	return entry != null and entry.picked_up

func is_door_unlocked(id: String) -> bool:
	return id in unlocked_doors

func unlock_door(id: String) -> void:
	if not is_door_unlocked(id):
		unlocked_doors.append(id)

func get_key_id(key_type: KeyType) -> String:
	var key_name = KeyType.keys()[key_type].to_lower() + "_key"
	return key_name
	# KeyType.RED -> "red_key" automatically


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

	moon_pieces = {
	"piece1": false,
	"piece2": false,
	"piece3": false,
}


func get_spawn_room_path() -> String:
	var room = ZONE_SPAWN_ROOMS.get(current_player_zone)
	return "res://scene/rooms/{z}/{r}".format({
		"z": current_player_zone,
		"r": room
	})
