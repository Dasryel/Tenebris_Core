@tool
extends PathFollow2D

# not used but left in case it is needed later ":D"
# this is a bad practice do not do this yourself

@export var speed: float = 0.2

var direction: float = 1.0

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_update_movement(delta)

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var old_pos = global_position # track PathFollow2D itself, not body
		_update_movement(delta)
		var new_pos = global_position
		var diff = new_pos - old_pos

		var body = get_child(0)
		body.global_position = old_pos # reset body
		body.move_and_collide(diff) # move properly

func _update_movement(delta: float) -> void:
	progress_ratio += speed * delta * direction
	if progress_ratio >= 1.0:
		progress_ratio = 1.0
		direction = -1.0
	elif progress_ratio <= 0.0:
		progress_ratio = 0.0
		direction = 1.0
