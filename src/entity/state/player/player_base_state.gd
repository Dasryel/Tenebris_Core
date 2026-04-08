class_name PlayerBaseState
extends BaseState


## Shorthand: transition on the [b]Locomotion[/b] layer.
func _go_to_loco(entity: Player, state_type: GDScript) -> void:
	_go_to(entity, Player.LOCOMOTION_LAYER, state_type)


## Shorthand: transition on the [b]Combat[/b] layer.
func _go_to_combat(entity: Player, state_type: GDScript) -> void:
	_go_to(entity, Player.COMBAT_LAYER, state_type)

func _update_orientation(entity: Player, h_dir: float) -> void:
	if h_dir > 0:
		entity.last_direction = Vector2.RIGHT
		entity.attack_hitbox.position.x = entity.attack_hitbox_offset
	elif h_dir < 0:
		entity.last_direction = Vector2.LEFT
		entity.attack_hitbox.position.x = - entity.attack_hitbox_offset
