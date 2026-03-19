extends Area2D

signal show_key
@export var key_id: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if key_id == "":
		print("WARNING: set key_id in Inspector!")
		queue_free()
		return

	if not GameState.keys.has(key_id):
		print("WARNING: key_id '", key_id, "' not found in GameState.keys, update the singleton")
		queue_free()
		return

	if GameState.keys[key_id]:
		print("Key already picked up")
		queue_free()

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
		GameState.keys[key_id] = true
		GameState.key_pickedup.emit()
		queue_free()
