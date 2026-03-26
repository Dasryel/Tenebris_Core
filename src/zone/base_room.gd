extends Node2D

func _ready() -> void:
    var p = preload("res://scene/player.tscn").instantiate()
    add_child(p)

    # 2. If GameState is empty (first room), look for "d"
    var target = GameState.target_entry_point if GameState.target_entry_point != "" else "PlayerSpawn"

    # 3. Snap to that marker
    var m = find_child(target)
    if m:
        p.global_position = m.global_position
    else:
        printerr("[BaseRoom] player marker not found")
