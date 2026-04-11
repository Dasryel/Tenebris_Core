extends Area2D

@export var sprites: Array[Texture2D]
@export var moon_sprite: Sprite2D
@export var reveal_duration: float = 2.5

var shader_mat := ShaderMaterial.new()
var _near_player: bool = false

func _ready() -> void:
	moon_sprite.texture = sprites[GameState.moon_phase]
	shader_mat.shader = load("res://resource/shader/add_moon_phase.gdshader")
	moon_sprite.material = shader_mat


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("use") and _near_player:
		if GameState.moon_phase >= 3:
			activate_portal()
		elif GameState.moon_pieces_count() > 0:
			consume_piece()


func consume_piece() -> void:
	for id in GameState.moon_pieces:
		if GameState.moon_pieces[id]:
			GameState.moon_pieces[id] = false
			GameState.moon_pieces_used[id] = true
			GameState.moon_piece_used.emit(id)
			break
	GameState.moon_phase += 1
	update_sprite()
	SignalBus.moon_phase_changed.emit(GameState.moon_phase)
	update_thought_bubble()


func update_sprite() -> void:
	if sprites.size() <= GameState.moon_phase:
		return

	shader_mat.set_shader_parameter("previous_tex", moon_sprite.texture)
	shader_mat.set_shader_parameter("noise_seed", randf_range(0.0, 999.0))

	moon_sprite.texture = sprites[GameState.moon_phase]

	if GameState.moon_phase == 0:
		shader_mat.set_shader_parameter("reveal", 1.0)
		return

	var tween = create_tween()
	tween.tween_method(
		func(v): shader_mat.set_shader_parameter("reveal", v),
		0.0, 1.0, reveal_duration
	)


func activate_portal() -> void:
	print("portal activated!")
	#get_tree().change_scene_to_file("res://scene/ui/end_screen.tscn")
	SignalBus.thought_bubble_show.emit("portal activated!")

	var tween = create_tween()
	tween.set_loops(3) # pulse 3 times
	tween.tween_property($PointLight2D, "energy", 3.0, 0.3)
	tween.tween_property($PointLight2D, "energy", 0.5, 0.3)
	await tween.finished

	# final bright flash then scene change
	var flash = create_tween()
	flash.tween_property($PointLight2D, "energy", 6.0, 0.5)
	await flash.finished


func update_thought_bubble() -> void:
	if GameState.moon_phase >= 3:
		SignalBus.thought_bubble_show.emit("Press E to teleport")
	elif GameState.moon_pieces_count() > 0:
		SignalBus.thought_bubble_show.emit("Press E to insert piece (%s/3)" % GameState.moon_phase)
	else:
		SignalBus.thought_bubble_show.emit("Seems like a portal... I need to find the pieces")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_near_player = true
		update_thought_bubble()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_near_player = false
		SignalBus.thought_bubble_hide.emit()
