extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	if GameState.spawn_position != Vector2.ZERO:
		global_position = GameState.spawn_position
		GameState.spawn_position = Vector2.ZERO
	GameState.key_pickedup.connect(key_obtained)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	update_animation(direction)

	if Input.is_action_just_pressed("heal"):
		heal()

	if Input.is_action_just_pressed("damage"):
		take_damage()		
func update_animation(direction: float) -> void:
	var sprite = $AnimatedSprite2D

	if direction != 0:
		sprite.play("run")
		sprite.flip_h = direction < 0
	else:
		sprite.play("idle")

func key_obtained() -> void:
	GameState.hasKey = true
	print("player has key: ", GameState.hasKey)

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
		GameState.spawn_position = Vector2(796, 451)
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


func _on_zone_1_room_1_to_room_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scene/rooms/zone2/room2.tscn")
	
	


func _on_zone_2_room_2_to_room_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameState.spawn_position = Vector2(920, 208)
		get_tree().change_scene_to_file("res://scene/rooms/zone2/room1.tscn")
