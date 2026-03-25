## Base entity with support for parallel state-machine layers
## (e.g. Locomotion + Combat running simultaneously).
class_name Entity
extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 300.0
@export var jump_velocity: float = -420.0
@export var recovery_jump_velocity: float = -250.0
@export var gravity: float = 1200.0
@export var knockback_force: float = -600

@export_group("Stats")
@export var max_jumps: int = 2
@export var hit_points: int = 3
@export var max_hit_points: int = 3

## Wire this up in the inspector or fetch it in _ready() of a subclass.
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.LEFT
var is_recovery_jump: bool = false
var jump_count: int = 0
var _state_machines: Dictionary[StringName, StateMachine] = {}


## Returns the [StateMachine] registered under [param layer].
func get_state_machine(layer: StringName) -> StateMachine:
    if not _state_machines.has(layer):
        push_error(
            "State machine layer '%s' not found. Available layers: %s"
            % [layer, str(_state_machines.keys())]
        )
        return null
    return _state_machines[layer]


## Registers a new state-machine layer with the given default state.
func _add_state_machine(layer: StringName, default_state: BaseState) -> StateMachine:
    if _state_machines.has(layer):
        push_error("State machine layer '%s' is already registered." % layer)

    var sm := StateMachine.new(default_state)
    _state_machines[layer] = sm
    return sm


func _process(delta: float) -> void:
    for sm in _state_machines.values():
        sm.update(self , delta)

func _on_entity_death():
    self.queue_free()


func heal(amount: int) -> void:
    if hit_points < max_hit_points:
        if hit_points + amount >= max_hit_points:
            hit_points = max_hit_points
        else:
            hit_points += amount

func get_attack_data() -> Dictionary:
    return {}

func get_attack_hitbox_collision() -> CollisionShape2D:
    return null

func play_anim(anim: String):
    sprite.flip_h = last_direction.x > 0
    sprite.play(anim)


func reset_jump_count() -> void:
    is_recovery_jump = false
    jump_count = 0
# end reset_jump_count

func get_knockback_direction(attacker_pos: Vector2, victim_pos: Vector2) -> Vector2:
    var direction := victim_pos - attacker_pos
    return direction.normalized()

func take_damage(_amount: int, _knockback_dir: Vector2) -> void:
    pass

func _on_animated_sprite_2d_frame_changed() -> void:
    var data: Dictionary = get_attack_data().get(sprite.animation, {})
    var active_frames: Array = data.get("active_frames", [])
    var is_active_frame = sprite.frame in active_frames
    var coll = get_attack_hitbox_collision()
    coll.set_deferred("disabled", !is_active_frame)


# Override this in subclasses to emit different signals
func _on_damage_taken(_current_hp: int) -> void:
    pass
