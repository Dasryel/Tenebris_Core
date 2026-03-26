## Abstract base class for all states in the state machine.
## Subclasses must override [method enter], [method update], and [method exit].
##
## Transition helpers ([method _go_to], [method _go_to_loco], [method _go_to_combat])
## are instance methods prefixed with [code]_[/code] to signal protected intent.
## They carry no mutable state, so they are safe with the flyweight [StateCache].
class_name BaseState
extends RefCounted

## Transitions [param entity] to a cached instance of [param state_type]
## on the given state-machine [param layer].
func _go_to(entity: Entity, layer: StringName, state_type: GDScript) -> void:
	var sm := entity.get_state_machine(layer)
	if sm:
		sm.change_state(StateCache.get_state(state_type), entity)
