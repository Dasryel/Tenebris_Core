class_name PlayerSlashingState
extends PlayerBaseState


func enter(entity: Player) -> void:
	if entity.is_taking_damage():
		print("player in hurt state")
		return

	entity.play_anim("slash1")
	AudioManager.play_sfx(entity.slash1_sound)

	# Connect to the signal bus
	SignalBus.player_sprite_anim_finished.connect(_on_anim_finished.bind(entity))

func _on_anim_finished(entity: Player) -> void:
	_go_to_loco(entity, PlayerIdleState)

func update(_entity: Entity, _delta: float) -> void:
	# Player must finish an initiated attack
	pass


func exit(_entity: Player) -> void:
	if SignalBus.player_sprite_anim_finished.is_connected(_on_anim_finished):
		SignalBus.player_sprite_anim_finished.disconnect(_on_anim_finished)
