extends Area2D

signal show_key


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() * 0.001) * 0.1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("key picked up!")
		GameState.key_pickedup.emit()
		queue_free()

	
