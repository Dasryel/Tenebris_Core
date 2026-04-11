extends Control

@onready var hearts = [$HeartsContainer/HpIcon, $HeartsContainer/HpIcon2, $HeartsContainer/HpIcon3]

@onready var log_messages = $LogMessages

const KeyType = preload("res://src/item/key_type.gd").KeyType
@export var key_texture: Texture2D
@export var key_icon_size: Vector2 = Vector2(32, 32)
var shader: Shader = preload("res://resource/shader/sprite_tint.gdshader")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.key_picked_up.connect(_on_key_picked_up)
	SignalBus.key_used.connect(_on_key_used)
	SignalBus.door_unlocked.connect(_on_key_used)
	SignalBus.player_hp_changed.connect(_on_player_hp_changed)
	SignalBus.log_entry_added.connect(_on_log_entry_added)
	SignalBus.debug_mode_toggled.connect(_on_debug_mode_toggled)
	log_messages.visible = GameState.debug_mode

	GameState.dj_pickedup.connect(show_dj)
	GameState.moon_piece_collected.connect(show_moon_piece)
	GameState.moon_piece_used.connect(hide_moon_piece)

	if GameState.has_dj:
		$DjIcon.visible = true

	if GameState.zone_text != "":
		show_zone_text(GameState.zone_text)
		GameState.zone_text = ""

	for id in GameState.moon_pieces:
		if GameState.moon_pieces[id]:
			show_moon_piece(id)

	_on_player_hp_changed(GameState.player_current_hp)
	_setup_ui_logger()

	for key in GameState.get_unused_keys():
		_add_key_to_ui(key)

func _setup_ui_logger() -> void:
	log_messages.push_font_size(10)
	log_messages.scroll_following = true
	log_messages.scroll_active = true

	if not OS.is_debug_build():
		log_messages.visible = false

func show_zone_text(text: String) -> void:
	$ZoneLabel.text = text
	$ZoneLabel.modulate.a = 0.0
	$ZoneLabel.visible = true

	var tween = create_tween()
	tween.tween_property($ZoneLabel, "modulate:a", 1.0, 0.8)
	await tween.finished

	await get_tree().create_timer(1.5).timeout

	tween = create_tween()
	tween.tween_property($ZoneLabel, "modulate:a", 0.0, 0.8)
	await tween.finished

	$ZoneLabel.visible = false

func _invalid_key_type() -> void:
	push_error("[Player ui] Attempting to add a picked up key of type NONE")

func _add_key_to_ui(key_id: String):
	var texture_rect = TextureRect.new()
	texture_rect.name = key_id
	texture_rect.texture = key_texture
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = key_icon_size

	var mat := ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("tint_color", GameState.keys[key_id].tint)
	texture_rect.material = mat

	$KeyList.add_child(texture_rect)

func _on_key_picked_up(key_id: String, key_type: KeyType) -> void:
	if key_type == KeyType.NONE:
		_invalid_key_type()
		return

	_add_key_to_ui(key_id)


func _on_key_used(key_id: String, key_type) -> void:
	if key_type == KeyType.NONE:
		_invalid_key_type()
		return

	var node = $KeyList.find_child(key_id)
	if node:
		node.queue_free()


func show_dj():
	$DjIcon.visible = true
	show_text("You can now double jump!")
	GameState.has_dj = true

func hide_dj():
	$DjIcon.visible = false

func show_text(text: String):
	$TextLabel.visible = true
	$TextLabel.text = text
	await get_tree().create_timer(2.0).timeout
	$TextLabel.visible = false

func show_moon_piece(id: String) -> void:
	show_text("You found a moon piece!")
	match id:
		"piece1": $MoonIcon1.visible = true
		"piece2": $MoonIcon2.visible = true
		"piece3": $MoonIcon3.visible = true

func hide_moon_piece(id: String) -> void:
	match id:
		"piece1": $MoonIcon1.visible = false
		"piece2": $MoonIcon2.visible = false
		"piece3": $MoonIcon3.visible = false

func _on_debug_mode_toggled():
	log_messages.visible = GameState.debug_mode

func _on_player_hp_changed(current_hp: int) -> void:
	GameState.player_current_hp = current_hp
	print("current hp: ", GameState.player_current_hp)

	for i in range(hearts.size()):
		if i < current_hp:
			hearts[i].texture = preload("res://asset/sprite/player/hp.png")
		else:
			hearts[i].texture = preload("res://asset/sprite/player/hp_empty.png")


func _on_lava_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.

func _on_log_entry_added(message: String) -> void:
	log_messages.append_text(message)
