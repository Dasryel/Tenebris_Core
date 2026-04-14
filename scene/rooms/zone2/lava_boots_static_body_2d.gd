extends StaticBody2D


func _ready() -> void:
	GameState.lavaboots_pickedup.connect(enable_lava_cover)
	if GameState.has_lava_boots:
		enable_lava_cover()
	else:
		print("no lava boots")

func enable_lava_cover():
	$CollisionShape2D.set_deferred("disabled", false)
	print("enabling lava cover, COLLISION.DISALBED: ", $CollisionShape2D.disabled)
