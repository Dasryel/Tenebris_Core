## Base entity with support for parallel state-machine layers
## (e.g. Locomotion + Combat running simultaneously).
class_name Entity
extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 300.0
@export var jump_velocity: float = -420.0
@export var recovery_jump_velocity: float = -250.0
@export var gravity: float = 1200.0
@export var knockback_force: float = -600

@export_group("Stats")
@export var max_jumps: int = 2
@export var hit_points: int = 3
@export var max_hit_points: int = 3

## Wire this up in the inspector or fetch it in _ready() of a subclass.
@export var animation_player: AnimationPlayer

var is_recovery_jump: bool = false
var jump_count: int = 0
var _state_machines: Dictionary[StringName, StateMachine] = {}


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
		sm.update(self , delta)

func die():
	GameState.player_died.emit()

func reset_jump_count() -> void:
	is_recovery_jump = false
	jump_count = 0
# end is_in_combat


func heal(amount: int) -> void:
	if hit_points < max_hit_points:
		if hit_points + amount >= max_hit_points:
			hit_points = max_hit_points
		else:
			hit_points += amount
