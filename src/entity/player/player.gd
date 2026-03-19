class_name Player
extends Entity

@export var loco_state_label: Label
@export var combat_state_label: Label
@export var thought_bubble: Label
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.LEFT

# A ridiculous hack to make gdscript PARSE THIS FILE
const CombatIdle = preload("res://src/entity/state/combat_idle_state.gd")

func play_anim(anim: String):
	sprite.flip_h = last_direction.x > 0
	sprite.play(anim)

func _ready() -> void:
	# Calls the _ready function of the parent 'Entity' class
	super ()

	GameState.key_pickedup.connect(key_obtained)

	if GameState.spawn_position != Vector2.ZERO:
		global_position = GameState.spawn_position
		GameState.spawn_position = Vector2.ZERO


	# Add the upper-body combat layer alongside the inherited locomotion layer.
	# We assume 'CombatLayer', 'StateCache', and 'CombatIdleState' are
	# accessible (e.g., as constants, members, or Autoloads).
	_add_state_machine(COMBAT_LAYER, StateCache.get_state(CombatIdleState))

	$AnimatedSprite2D.animation_finished.connect(_on_player_sprite_finished)
# end ready _ready


func _process(delta: float) -> void:
	super (delta)

	var sm = get_state_machine(LOCOMOTION_LAYER)
	if not sm:
		return

	var current_state = sm.current_state
	if not current_state:
		loco_state_label.text = "State: Initializing..."
		return

	loco_state_label.text = "State: %s" % current_state.get_script().get_global_name()

	sm = get_state_machine(COMBAT_LAYER)
	if not sm:
		return

	current_state = sm.current_state
	if not current_state:
		combat_state_label.text = "State: Initializing..."
		return

	combat_state_label.text = "State: %s" % current_state.get_script().get_global_name()
# end _process

func _on_player_sprite_finished() -> void:
	SignalBus.player_sprite_anim_finished.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("heal"):
		heal()

	if event.is_action_pressed("damage"):
		take_damage()
# end _unhandled_input


func key_obtained() -> void:
	GameState.has_key = true
	print("player has key: ", GameState.has_key)


func take_damage() -> void:
	GameState.current_hp -= 1
	GameState.current_hp = clamp(GameState.current_hp, 0, GameState.max_hp)
	GameState.hp_changed.emit(GameState.current_hp, GameState.max_hp)
	if GameState.current_hp <= 0:
		GameState.player_died.emit()


func heal() -> void:
	if GameState.current_hp >= GameState.max_hp:
		print("full hp!")
		return
	GameState.current_hp += 1
	GameState.current_hp = clamp(GameState.current_hp, 0, GameState.max_hp)
	GameState.hp_changed.emit(GameState.current_hp, GameState.max_hp)


func _on_room_1_to_room_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scene/rooms/zone1/room2.tscn")


func _on_room_2_to_room_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameState.spawn_position = Vector2(922, 196)
		get_tree().change_scene_to_file("res://scene/rooms/zone1/room1.tscn")

func _on_room_2_to_room_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scene/rooms/zone1/room3.tscn")

func _on_room_3_to_room_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameState.spawn_position = Vector2(1129, 187)
		get_tree().change_scene_to_file("res://scene/rooms/zone1/room2.tscn")


func _on_lava_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		take_damage()

func _on_lava_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		pass
		#$"../lava/Timer".stop()


func _on_timer_timeout() -> void:
	pass
	#take_damage()
