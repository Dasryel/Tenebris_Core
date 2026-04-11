class_name EnemyDeathState
extends EnemyBaseState

func enter(entity: Enemy) -> void:
	entity.collision_layer = 0
	entity.collision_mask = 0

	# Disable every CollisionShape2D in the entire enemy
	for child in entity.find_children("*", "CollisionShape2D", true):
		child.set_deferred("disabled", true)

	# Disable every Area2D so their signals stop firing
	for area in entity.find_children("*", "Area2D", true):
		area.set_deferred("monitorable", false)
		area.set_deferred("monitoring", false)

	entity.state_label.text = "EnemyDeathState"
	entity.set_physics_process(false)
	entity.sprite.play("die")
	await entity.sprite.animation_finished
	entity.queue_free()


func update(_entity: Enemy, _delta: float) -> void:
	pass


func exit(_entity: Enemy) -> void:
	pass
