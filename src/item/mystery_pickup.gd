extends Area2D

@export var id: String

func _ready() -> void:
	if id == "":
		print("WARNING: id not set in Inspector!")
		return
	if GameState.mystery_pieces[id]:
		queue_free()

func _process(_delta: float) -> void:
	pass
	#position.y += sin(Time.get_ticks_msec() * 0.001) * 1.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.mystery_pieces[id] = true
		GameState.mystery_piece_collected.emit()
		queue_free()
