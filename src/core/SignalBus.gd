extends Node

const KeyType = preload("res://src/item/key_type.gd").KeyType

signal thought_bubble_show(text: String)
signal thought_bubble_hide()

signal show_text_on_player_ui(text: String)

signal moon_phase_changed(phase)

signal player_sprite_anim_finished()
signal player_hp_changed(new_hit_points: int)
signal extra_jump_pickup()

signal door_unlocked(door_id: String)

signal camera_bounds_changed(top_left: Vector2, bottom_right: Vector2)
signal camera_zoom_changed(new_zoom: Vector2)

signal key_picked_up(key_id: String, key_type: KeyType)
signal key_used(key_id: String, key_type: KeyType)
'''
No idea if this must be done like so... First player picks up key -> gamestate changes.
THEN gamestate emits that key storage is changed -> avoids potential race conditions and
problems with player UI updates.
'''
signal key_storage_key_added(key_id: String, key_type: KeyType)
signal key_storage_key_removed(key_id: String, key_type: KeyType)

signal log_entry_added(message: String)
signal debug_mode_toggled()

signal play_game_music(track: String)
