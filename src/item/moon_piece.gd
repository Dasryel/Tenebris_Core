extends Area2D
@export var id: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if id == "":
		print("WARNING: set id in Inspector!")
		queue_free()
		return
	if GameState.moon_pieces[id] or GameState.moon_pieces_used[id]:
		queue_free()
		return

func _process(_delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() * 0.001) * 0.1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Guard against invalid key_id in case _ready() returned early
		if id == "":
			print("WARNING: key pickup with invalid empty id")
			return

		SignalBus.show_text_on_player_ui.emit("You found a moon piece!")
		GameState.piece_pickedup(id)
		queue_free()
