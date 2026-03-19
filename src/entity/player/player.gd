class_name Player
extends Entity

# debug labels
@export var loco_state_label: Label
@export var combat_state_label: Label

# visible player tooltip/info bubble
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

    # stats
    speed = 300.0
    jump_velocity = -420.0
    gravity = 1200.0

    GameState.key_pickedup.connect(key_obtained)
    # GameState.has_key = true

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
    _update_state_label(LOCOMOTION_LAYER, loco_state_label)
    _update_state_label(COMBAT_LAYER, combat_state_label)
# end _process

func _update_state_label(layer_name: StringName, label: Label) -> void:
    var sm = get_state_machine(layer_name)
    if not sm:
        return

    var current_state = sm.current_state
    if not current_state:
        label.text = "State: Initializing..."
        return

    label.text = "State: %s" % current_state.get_script().get_global_name()

func _on_player_sprite_finished() -> void:
    SignalBus.player_sprite_anim_finished.emit()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("heal"):
        heal()

    if event.is_action_pressed("damage"):
        take_damage()
# end _unhandled_input


func update_animation(direction: float) -> void:
    sprite = $AnimatedSprite2D

    if direction != 0:
        sprite.play("run")
        sprite.flip_h = direction < 0
    else:
        sprite.play("idle")


func key_obtained() -> void:
    GameState.has_key = true
    print("player has key: ", GameState.has_key)

func update_hp(amount: int) -> void:
    GameState.current_hp += amount
    GameState.current_hp = clamp(GameState.current_hp, 0, GameState.max_hp)
    GameState.hp_changed.emit(GameState.current_hp, GameState.max_hp)

    if GameState.current_hp <= 0:
        GameState.player_died.emit()
    elif amount > 0 and GameState.current_hp == GameState.max_hp:
        print("Back to full health!")

func take_damage() -> void:
    update_hp(-1)


func heal() -> void:
    update_hp(1)
