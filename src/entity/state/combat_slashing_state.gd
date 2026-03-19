class_name CombatSlashingState
extends BaseState


func _on_anim_finished(entity: Entity) -> void:
	_go_to_combat(entity, CombatIdleState)

func enter(entity: Entity) -> void:
	entity.play_anim("slash1")

	# Connect to the signal bus
	SignalBus.player_sprite_anim_finished.connect(_on_anim_finished.bind(entity))


func update(entity: Entity, _delta: float) -> void:
	# Cancel attack on movement
	if not entity.is_loco_idling():
		_go_to_combat(entity, CombatIdleState)
		return


func exit(_entity: Entity) -> void:
	if SignalBus.player_sprite_anim_finished.is_connected(_on_anim_finished):
		SignalBus.player_sprite_anim_finished.disconnect(_on_anim_finished)
