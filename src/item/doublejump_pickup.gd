extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.has_dj:
		queue_free()
		print("pick up removed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameState.dj_pickedup.emit()
		entity.max_jumps = 2
		print(entity.max_jumps)
		queue_free()
