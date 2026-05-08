extends Area2D

@export_group("Sound effects")
@export var pickup_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if GameState.player_current_hp == 3:
			print("full hp")
			SignalBus.thought_bubble_show.emit("Full hp")
			await get_tree().create_timer(0.7).timeout
			SignalBus.thought_bubble_hide.emit()
			return
		else:
			AudioManager.play_sfx(pickup_sound)
			var new_hp = GameState.player_current_hp + 1
			print("old", GameState.player_current_hp, " new:", new_hp)
			GameState.player_current_hp += 1
			SignalBus.player_hp_changed.emit(new_hp)
			self.queue_free()
