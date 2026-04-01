extends Node

@warning_ignore("unused_signal")
signal thought_bubble_show(text: String)

@warning_ignore("unused_signal")
signal thought_bubble_hide()

@warning_ignore("unused_signal")
signal player_sprite_anim_finished()

@warning_ignore("unused_signal")
signal door_unlocked(door_id: String)

@warning_ignore("unused_signal")
signal player_hp_changed(new_hit_points: int)

@warning_ignore("unused_signal")
signal extra_jump_pickup()

@warning_ignore("unused_signal")
signal camera_bounds_changed(top_left: Vector2, bottom_right: Vector2)
