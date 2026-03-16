## Base entity with support for parallel state-machine layers
## (e.g. Locomotion + Combat running simultaneously).
class_name Entity
extends CharacterBody2D

const LOCOMOTION_LAYER: StringName = &"Locomotion"
const COMBAT_LAYER: StringName     = &"Combat"

@export var speed: float          = 300.0
@export var jump_velocity: float  = -420.0
@export var gravity: float        = 1200.0

## Wire this up in the inspector or fetch it in _ready() of a subclass.
@export var animation_player: AnimationPlayer

var _state_machines: Dictionary[StringName, StateMachine] = {}


func _ready() -> void:
	_add_state_machine(LOCOMOTION_LAYER, StateCache.get_state(FallingState))


## Returns the [StateMachine] registered under [param layer].
func get_state_machine(layer: StringName) -> StateMachine:
	if not _state_machines.has(layer):
		push_error(
			"State machine layer '%s' not found. Available layers: %s"
			% [layer, str(_state_machines.keys())]
		)
		return null
	return _state_machines[layer]


## Registers a new state-machine layer with the given default state.
func _add_state_machine(layer: StringName, default_state: BaseState) -> StateMachine:
	if _state_machines.has(layer):
		push_error("State machine layer '%s' is already registered." % layer)

	var sm := StateMachine.new(default_state)
	_state_machines[layer] = sm
	return sm


func _process(delta: float) -> void:
	for sm in _state_machines.values():
		sm.update(self, delta)