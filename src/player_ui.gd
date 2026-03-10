extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.key_pickedup.connect(show_key)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_key():
	$KeyIcon.visible = true
	$KeyLabel.visible = true
	await get_tree().create_timer(2.0).timeout
	$KeyLabel.visible = false
	
func hide_key():
	$KeyIcon.visible = false
