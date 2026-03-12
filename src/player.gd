extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var hasKey = false
var max_hp = 3
var current_hp = 3


func _ready() -> void:
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if Input.is_action_just_pressed("heal"):
		print("heal")
		heal()
	if Input.is_action_just_pressed("damage"):
		print("damage")
		take_damage()
	
	
	GameState.key_pickedup.connect(key_obtained)
	
func key_obtained():
	hasKey = true
	print("player has key: ", hasKey)
	
func take_damage():
	current_hp -= 1
	current_hp = clamp(current_hp, 0, max_hp)
	if current_hp <= 0:
		print("dead")
		GameState.player_died.emit()
	GameState.hp_changed.emit(current_hp, max_hp)
	
func heal():
	if current_hp >= max_hp:
		print("full")
		return
	current_hp += 1
	current_hp = clamp(current_hp, 0, max_hp)
	GameState.hp_changed.emit(current_hp, max_hp)

	
	
