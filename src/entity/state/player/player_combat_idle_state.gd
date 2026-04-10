class_name PlayerCombatIdleState
extends PlayerBaseState

# A ridiculous hack to make gdscript PARSE THIS FILE
const CombatSlashing = preload("res://src/entity/state/player/player_combat_slashing_state.gd")

func enter(entity: Entity) -> void:
	if entity.is_taking_damage():
		print("player in hurt state")
		return

	entity.play_anim("idle")


func update(entity: Entity, _delta: float) -> void:
	if Input.is_action_just_pressed(GameInput.ATTACK1):
		_go_to_combat(entity, PlayerCombatSlashingState)
		return

func exit(_entity: Entity) -> void:
	pass
