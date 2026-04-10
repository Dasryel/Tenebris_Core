class_name PlayerCombatSlashingState
extends PlayerBaseState


func enter(entity: Entity) -> void:
	if entity.is_taking_damage():
		print("player in hurt state")
		return

	entity.play_anim("slash1")

	# Connect to the signal bus
	SignalBus.player_sprite_anim_finished.connect(_on_anim_finished.bind(entity))

func _on_anim_finished(entity: Entity) -> void:
	_go_to_combat(entity, PlayerCombatIdleState)

func update(entity: Entity, _delta: float) -> void:
	# Cancel attack on movement
	if not entity.is_loco_idling():
		_go_to_combat(entity, PlayerCombatIdleState)
		return


func exit(_entity: Entity) -> void:
	if SignalBus.player_sprite_anim_finished.is_connected(_on_anim_finished):
		SignalBus.player_sprite_anim_finished.disconnect(_on_anim_finished)
