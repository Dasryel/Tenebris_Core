class_name EnemyDeathState
extends EnemyBaseState

func enter(entity: Enemy) -> void:
	entity.state_label.text = "EnemyDeathState"
	entity.sprite.play("die")
	await entity.sprite.animation_finished
	entity.set_process(false)
	entity.queue_free()


func update(_entity: Enemy, _delta: float) -> void:
	pass


func exit(_entity: Enemy) -> void:
	pass
