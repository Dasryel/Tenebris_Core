extends Node


signal thought_bubble_show(text: String)
signal thought_bubble_hide()

signal moon_phase_changed(phase)

signal player_sprite_anim_finished()
signal player_hp_changed(new_hit_points: int)
signal extra_jump_pickup()

signal door_unlocked(door_id: String)

signal camera_bounds_changed(top_left: Vector2, bottom_right: Vector2)
signal camera_zoom_changed(new_zoom: Vector2)

signal key_picked_up(key_id: String)
signal key_used(key_id: String)
