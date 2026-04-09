## Manages the currently active [BaseState] and handles transitions.
class_name StateMachine
extends RefCounted

## The currently active state.
var current_state: BaseState


func _init(default_state: BaseState) -> void:
	# NOTE: Enter is intentionally NOT called on the default state here,
	# matching the original design. The first _process tick drives Update.
	current_state = default_state


## Exits the current state, activates [param new_state], and calls its enter().
func change_state(new_state: BaseState, entity: Entity) -> void:
	if current_state:
		current_state.exit(entity)
	current_state = new_state
	if current_state:
		current_state.enter(entity)


## Delegates the per-frame update to the current state.
func update(entity: Entity, delta: float) -> void:
	if current_state:
		current_state.update(entity, delta)

func start(entity: Entity) -> void:
	current_state.enter(entity)

func notify(entity: Entity, event: int) -> void:
	if current_state:
		current_state.on_notify(entity, event)

func terminate() -> void:
	current_state = null
