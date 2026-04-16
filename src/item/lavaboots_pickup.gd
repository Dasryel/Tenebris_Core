extends Area2D

@export_group("Sound effects")
@export var pickup_sound: AudioStream


func _ready() -> void:
	if GameState.has_lava_boots:
		queue_free()
		print("lava boots pick up removed")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.has_lava_boots = true
		AudioManager.play_sfx(pickup_sound)
		GameState.lavaboots_pickedup.emit()
		#$"../Lava/LavaBootsStaticBody2D".enable_lava_cover()
		queue_free()
