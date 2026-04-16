extends Node

signal key_pickedup
signal player_died
signal dj_pickedup
signal lavaboots_pickedup
signal game_paused
signal moon_piece_collected(id)
signal moon_piece_used(id)
signal enable_lavacover
signal mystery_piece_collected



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_map"):
		get_tree().change_scene_to_file("res://scene/rooms/zone3/room1.tscn")

	elif event.is_action_pressed("toggle_debug"):
		print("debug mode toggled")
		debug_mode = !debug_mode
		SignalBus.debug_mode_toggled.emit()

	elif event.is_action_pressed("take_screenshot"):
		_take_screenshot()

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

var has_dj: bool = false
var has_lava_boots: bool = false

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

var mystery_pieces: Dictionary = {
	"m1": false,
	"m2": false,
	"m3": false,
	"m4": false,
}

var moon_pieces: Dictionary = {
	"piece1": false,
	"piece2": false,
	"piece3": false,
	"piece4": false,
}
var moon_pieces_used: Dictionary = {
	"piece1": false,
	"piece2": false,
	"piece3": false,
	"piece4": false,
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

func _on_key_picked_up(key_id: String, key_type: KeyType) -> void:
	keys[key_id].picked_up = true
	SignalBus.key_storage_key_added.emit(key_id, key_type)

func _on_key_used(key_id: String, key_type: KeyType) -> void:
	keys[key_id].used = true
	SignalBus.key_storage_key_removed.emit(key_id, key_type)

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
	
func mystery_pieces_count() -> int:
	var count = 0
	for piece in mystery_pieces.values():
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
	"piece4": false,
}


func get_spawn_room_path() -> String:
	var room = ZONE_SPAWN_ROOMS.get(current_player_zone)
	return "res://scene/rooms/{z}/{r}".format({
		"z": current_player_zone,
		"r": room
	})

func _take_screenshot() -> void:
	# Saves screenshot to user://
	# Windows: %APPDATA%\Godot\app_userdata\[project_name]
	# macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
	# Linux: ~/.local/share/godot/app_userdata/[project_name]
	var user_path: String = "user://screenshots/"

	# Ensure the screenshots directory exists
	if not DirAccess.dir_exists_absolute(user_path):
		var err: Error = DirAccess.make_dir_recursive_absolute(user_path)
		if err != OK:
			push_error("Failed to create screenshots directory: ", error_string(err))
			return

	var moment: Dictionary = Time.get_datetime_dict_from_system()
	var time: String = "%s-%s-%s_%s_%s-%s" % [
		moment.get("year"),
		moment.get("month"),
		moment.get("day"),
		moment.get("hour"),
		moment.get("minute"),
		moment.get("second")
		]
	var path: String = user_path + "tenebriscore_" + time + ".png"
	var captured_image: Image = get_viewport().get_texture().get_image()

	captured_image.save_png(path)

	var err2 = captured_image.save_png(path)
	if err2 != OK:
		push_error("Failed to save screenshot: ", error_string(err2))
	else:
		print("Saved screenshot to: ", path)
