class_name Enemy
extends Entity

@export var state_label: Label

const ENEMY_LAYER: StringName = &"Enemy"

func _init():
	hit_points = 2

func _process(delta: float) -> void:
	for sm in _state_machines.values():
		sm.update(self , delta)

# Could use push_error("play_death_effect() not implemented in: " + get_class()) in these instead
func _ready() -> void:
	pass

# hopefully this really kills the monster
func _on_entity_death():
	pass

@warning_ignore("unused_parameter")
func take_damage(amount: int, knockback_dir: Vector2) -> void:
	pass

func play_death_effect():
	pass
