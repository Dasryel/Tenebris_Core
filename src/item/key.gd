extends Area2D

signal show_key
@export var key_id: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if key_id == "":
		print("WARNING: set key_id in Inspector!")
		queue_free()
		return

	var is_key_picked_up = GameState.keys.get(key_id)
	print("key status for key: ", key_id, " is: ", is_key_picked_up)
	if is_key_picked_up == true:
		print("Key already picked up")
		queue_free()

	if not GameState.keys.has(key_id):
		print("WARNING: key_id '", key_id, "' not found in GameState.keys, update the singleton")
		queue_free()
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() * 0.001) * 0.1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Guard against invalid key_id in case _ready() returned early
		if key_id == "":
			print("WARNING: key pickup with invalid empty key_id")
			return

		if not GameState.keys.has(key_id):
			print("WARNING: key pickup with unknown key_id '", key_id, "'")
			return

		print("key picked up!")
		SignalBus.key_picked_up.emit(key_id)
		queue_free()
