extends Node2D

@export var camera_bounds: Node2D

func _ready() -> void:
	var p = preload("res://scene/player.tscn").instantiate()
	add_child(p)

	# A really fraglile way to do this, but hopefully it is good enough
	if not GameState.player_is_dead:
		var scene = get_tree().current_scene.scene_file_path
		var parts = scene.split('/')
		GameState.current_player_zone = parts.get(4)
		GameState.current_player_room = parts.get(5)
	else:
		GameState.target_entry_point = ""
		GameState.player_is_dead = false

	# 2. If GameState is empty (first room), look for "d"
	var target = GameState.target_entry_point if GameState.target_entry_point != "" else "PlayerSpawn"

	# 3. Snap to that marker
	var m = find_child(target)
	if m:
		# hack for debug map
		if GameState.current_player_zone == "zone3" and GameState.current_player_room == "room1.tscn":
			setup_debug_player(p)
		p.global_position = m.global_position
	else:
		printerr("[BaseRoom] player marker not found")

func setup_debug_player(p):
	p.scale = Vector2(0.2, 0.2)
	p.speed /= 2
	p.jump_velocity /= 2
	p.gravity /= 2
	p.recovery_jump_velocity /= 2
	p.knockback_force /= 2
	p.air_acceleration /= 2
	p.opposing_jump_drag /= 2

	var camera = PlayerCamera.new(p)
	p.add_child(camera)
	_setup_camera_bounds()

	# A really fraglile way to do this, but hopefully it is good enough
	if not GameState.player_is_dead:
		var scene = get_tree().current_scene.scene_file_path
		var parts = scene.split('/')
		GameState.current_player_zone = parts.get(4)
		GameState.current_player_room = parts.get(5)
	else:
		GameState.target_entry_point = ""
		GameState.player_is_dead = false

	# 2. If GameState is empty (first room), look for "d"
	var target = GameState.target_entry_point if GameState.target_entry_point != "" else "PlayerSpawn"

	# 3. Snap to that marker
	var m = find_child(target)
	if m:
		# hack for debug map
		if GameState.current_player_zone == "zone3" and GameState.current_player_room == "room1.tscn":
			_setup_debug_player(p)
		p.global_position = m.global_position
	else:
		printerr("[BaseRoom] player marker not found")

func _setup_camera_bounds():
	var top_left = camera_bounds.get_node("TopLeft")
	var bottom_right = camera_bounds.get_node("BottomRight")

	SignalBus.camera_bounds_changed.emit(top_left.global_position, bottom_right.global_position)

func _setup_debug_player(p):
	p.scale = Vector2(0.2, 0.2)
	p.speed /= 2
	p.jump_velocity /= 2
	p.gravity /= 2
	p.recovery_jump_velocity /= 2
	p.knockback_force /= 2
	p.air_acceleration /= 2
	p.opposing_jump_drag /= 2
