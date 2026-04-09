class_name PlayerHurtState
extends PlayerBaseState

func enter(entity: Entity) -> void:
	entity.play_anim("hurt")
	entity.sprite.animation_finished.connect(_on_animation_finished.bind(entity))

func update(_entity: Entity, _delta: float) -> void:
	pass

func _on_animation_finished(entity: Entity) -> void:
	if entity.is_on_floor():
		_go_to_loco(entity, PlayerIdleState)
	else:
		_go_to_loco(entity, PlayerFallingState)

func exit(entity: Entity) -> void:
	if entity.sprite.animation_finished.is_connected(_on_animation_finished):
		entity.sprite.animation_finished.disconnect(_on_animation_finished)
