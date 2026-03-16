extends Control

@onready var hearts = [$HeartsContainer/HpIcon, $HeartsContainer/HpIcon2, $HeartsContainer/HpIcon3]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.key_pickedup.connect(show_key)
	GameState.hp_changed.connect(update_hp)
	
	update_hp(GameState.current_hp, GameState.max_hp)
	if GameState.hasKey:
		$KeyIcon.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print(hearts.size())
	
func show_key():
	
	$KeyIcon.visible = true
	$KeyLabel.visible = true
	await get_tree().create_timer(2.0).timeout
	$KeyLabel.visible = false
	
func hide_key():
	$KeyIcon.visible = false
	
func update_hp(current_hp: int, max_hp: int) -> void:
	for i in range(hearts.size()):
		if i < current_hp:
			hearts[i].texture = preload("res://asset/sprite/player/hp.png")
		else:
			hearts[i].texture = preload("res://asset/sprite/player/hp_empty.png")


func _on_lava_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
