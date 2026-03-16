## Abstract base class for all states in the state machine.
## Subclasses must override [method enter], [method update], and [method exit].
##
## Transition helpers ([method _go_to], [method _go_to_loco], [method _go_to_combat])
## are instance methods prefixed with [code]_[/code] to signal protected intent.
## They carry no mutable state, so they are safe with the flyweight [StateCache].
class_name BaseState
extends RefCounted


## Called when the state machine transitions into this state.
func enter(_entity: Entity) -> void:
	pass


## Called every frame while this state is active.
func update(_entity: Entity, _delta: float) -> void:
	pass


## Called when the state machine transitions out of this state.
func exit(_entity: Entity) -> void:
	pass


## Transitions [param entity] to a cached instance of [param state_type]
## on the given state-machine [param layer].
func _go_to(entity: Entity, layer: StringName, state_type: GDScript) -> void:
	var sm := entity.get_state_machine(layer)
	if sm:
		sm.change_state(StateCache.get_state(state_type), entity)


## Shorthand: transition on the [b]Locomotion[/b] layer.
func _go_to_loco(entity: Entity, state_type: GDScript) -> void:
	_go_to(entity, Entity.LOCOMOTION_LAYER, state_type)


## Shorthand: transition on the [b]Combat[/b] layer.
func _go_to_combat(entity: Entity, state_type: GDScript) -> void:
	_go_to(entity, Entity.COMBAT_LAYER, state_type)