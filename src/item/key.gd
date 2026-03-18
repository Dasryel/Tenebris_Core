extends Area2D

signal show_key
@export var key_id: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if key_id == "":
		print("WARNING: set key_id in Inspector!")
		return
	if not GameState.keys.has(key_id):
		print("WARNING: key_id '", key_id, "' not found in GameState.keys, update the singleton")
		return
	if GameState.keys[key_id]:
		print("Key already picked up")
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += sin(Time.get_ticks_msec() * 0.001) * 0.1


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("key picked up!")
		GameState.keys[key_id] = true
		GameState.key_pickedup.emit()
		queue_free()

	
