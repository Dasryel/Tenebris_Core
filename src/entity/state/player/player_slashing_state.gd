class_name PlayerSlashingState
extends PlayerBaseState


func enter(entity: Player) -> void:
	if entity.is_taking_damage():
		print("player in hurt state")
		return

	entity.play_anim("slash1")
	AudioManager.play_sfx(entity.slash1_sound)

	entity.anim_callback = _on_anim_finished.bind(entity)
	SignalBus.player_sprite_anim_finished.connect(entity.anim_callback, CONNECT_ONE_SHOT)

func _on_anim_finished(entity: Player) -> void:
	_go_to_loco(entity, PlayerIdleState)

func update(_entity: Entity, _delta: float) -> void:
	# Player must finish an initiated attack
	pass


func exit(entity: Player) -> void:
	if entity.anim_callback and SignalBus.player_sprite_anim_finished.is_connected(entity.anim_callback):
		SignalBus.player_sprite_anim_finished.disconnect(entity.anim_callback)
	entity.anim_callback = Callable()
