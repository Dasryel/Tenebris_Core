extends Node2D

const DEFAULT_CAMERA_ZOOM: Vector2 = Vector2(0.6, 0.6)

@export var camera_bounds: Node2D
@export var camera_zoom: Vector2 = DEFAULT_CAMERA_ZOOM

func _ready() -> void:
	var player = preload("res://scene/player.tscn").instantiate()
	add_child(player)

	_setup_player_camera()

	# A really fraglile way to do this, but hopefully it is good enough
	if not GameState.player_is_dead:
		var scene = get_tree().current_scene.scene_file_path
		var parts = scene.split('/')
		var zone = parts.get(4)
		var room = parts.get(5)

		if zone != GameState.current_player_zone:
			match zone:
				"zone1":
					SignalBus.play_game_music.emit("zone1")
				"zone2":
					SignalBus.play_game_music.emit("zone2")
				_:
					push_error("[BaseRoom] unknown zone when selecting music", zone)

		GameState.current_player_zone = zone
		GameState.current_player_room = room
	else:
		GameState.target_entry_point = ""
		GameState.player_is_dead = false

	# 2. If GameState is empty (first room), look for "d"
	var target = GameState.target_entry_point if GameState.target_entry_point != "" else "PlayerSpawn"

	# 3. Snap to that marker
	var marker = find_child(target)
	if marker:
		player.global_position = marker.global_position
	else:
		printerr("[BaseRoom] player marker not found")
# END _ready


func _setup_player_camera():
	var top_left = camera_bounds.get_node("TopLeft")
	var bottom_right = camera_bounds.get_node("BottomRight")

	if camera_zoom != DEFAULT_CAMERA_ZOOM:
		SignalBus.camera_zoom_changed.emit(camera_zoom)

	if top_left and bottom_right:
		SignalBus.camera_bounds_changed.emit(
			top_left.global_position,
			bottom_right.global_position
			)
	else:
		printerr("[BaseRoom] Could not find camera bounds")
# END _setup_camera_bounds
