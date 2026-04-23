extends Control

@onready var pieces = [
	$CanvasLayer/PuzzleHolder/Piece1,
	$CanvasLayer/PuzzleHolder/Piece2,
	$CanvasLayer/PuzzleHolder/Piece3,
	$CanvasLayer/PuzzleHolder/Piece4,
]
@onready var relic_label = $CanvasLayer/VBoxContainer/PieceLabel
@onready var continue_label = $CanvasLayer/VBoxContainer/ContinueLabel
@onready var status_label = $CanvasLayer/VBoxContainer/StatusLabel
@onready var overlay = $CanvasLayer/DarkOverlay
@onready var laser_eyes = $CanvasLayer/LaserTexture

var can_continue: bool = false

func _ready() -> void:
	laser_eyes.visible = false
	overlay.color = Color(0, 0, 0, 1)
	for piece in pieces:
		piece.modulate.a = 0.0
	relic_label.modulate.a = 0.0
	continue_label.modulate.a = 0.0
	await get_tree().create_timer(0.3).timeout
	await fade_in_sequence()

func fade_in_sequence() -> void:
	# fade out the black overlay first
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 1.0)
	await tween.finished

	# reveal each piece one by one
	var ids = ["m1", "m2", "m3", "m4"]
	for i in range(pieces.size()):
		if GameState.mystery_pieces[ids[i]]:
			var t = create_tween()
			t.tween_property(pieces[i], "modulate:a", 1.0, 0.5)
			await t.finished
		await get_tree().create_timer(0.3).timeout

	# show relic count
	relic_label.text = str(GameState.mystery_pieces_count()) + " / 4 relics found"

	var rt = create_tween()
	rt.tween_property(relic_label, "modulate:a", 1.0, 0.6)
	await rt.finished

	await get_tree().create_timer(0.5).timeout


	var st = create_tween()
	if GameState.mystery_pieces_count() == 4:
		status_label.text = "Monke is proud! :]"
		st.tween_property(status_label, "modulate:a", 1.0, 0.6)
		laser_eyes.visible = true
	else:
		status_label.text = "Monke is disapointed! >:["
		st.tween_property(status_label, "modulate:a", 1.0, 0.6)
	await st.finished
	await get_tree().create_timer(0.5).timeout

	# show continue prompt
	var ct = create_tween()
	ct.tween_property(continue_label, "modulate:a", 1.0, 0.6)
	await ct.finished


	can_continue = true

func _process(_delta: float) -> void:
	if can_continue and Input.is_action_just_pressed("use"):
		get_tree().change_scene_to_file("res://scene/ui/credits.tscn")
