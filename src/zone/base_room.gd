extends Node2D

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
        p.global_position = m.global_position
    else:
        printerr("[BaseRoom] player marker not found")
