extends Control

@onready var hearts = [$HeartsContainer/HpIcon, $HeartsContainer/HpIcon2, $HeartsContainer/HpIcon3]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GameState.key_pickedup.connect(show_key)
    GameState.dj_pickedup.connect(show_dj)
    GameState.door_unlocked.connect(hide_key)
    SignalBus.player_hp_changed.connect(_on_player_hp_changed)

    if GameState.has_key:
        $KeyIcon.visible = true

    if GameState.has_dj:
        $DjIcon.visible = true

    if GameState.zone_text != "":
        show_zone_text(GameState.zone_text)
        GameState.zone_text = ""

    _on_player_hp_changed(GameState.player_current_hp)

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

func show_key():
    $KeyIcon.visible = true
    show_text("You picked up key!")

func hide_key():
    $KeyIcon.visible = false

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
