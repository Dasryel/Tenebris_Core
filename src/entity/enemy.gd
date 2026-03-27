class_name Enemy
extends Entity

@export var state_label: Label

const ENEMY_LAYER: StringName = &"Enemy"

var idle_timer: float = 0.0
var recovery_timer: float = 0.0

@export_group("Enemy params")
# TODO These should be defined in a resource, or as export vars
# So they could be customized earlier
@export var ATTACK_RANGE := 100.0 # How long before enemy can attack again after recovery
@export var ABANDON_RANGE := 600.0
@export var DETECTION_RANGE := 400.0
@export var PURSUIT_SPEED := 160.0
@export var RECOVERY_DURATION := 0.6 # seconds before enemy acts again
@export var FLASH_INTERVAL := 0.08 # seconds between visibility toggles
@export var IDLE_WAIT_MIN := 1.0
@export var IDLE_WAIT_MAX := 3.0

@export_group("Navigation Rays")
@export var rotator: Node2D
@export var ray_front: RayCast2D
@export var ray_left: RayCast2D
@export var ray_right: RayCast2D

@export_group("Attack Hitbox")
@export var attack_hitbox: Area2D
@export var attack_hitbox_offset: float = 80.0
@export var attack_hitbox_collision: CollisionShape2D

const ATTACK_DATA: Dictionary = {
	"attack": {
		"active_frames": [6],
		"damage": 1,
		"knockback_force": 200.0,
		"target_group": "player_hurtbox",
	},
}

func _init():
	hit_points = 2

func _process(delta: float) -> void:
	for sm in _state_machines.values():
		sm.update(self , delta)

func _ready() -> void:
	last_direction = Vector2.RIGHT
	_add_state_machine(ENEMY_LAYER, StateCache.get_state(EnemyIdleState))

	var sm = get_state_machine(ENEMY_LAYER)
	var current_state = sm.current_state
	current_state.enter(self )

# hopefully this really kills the monster
func _on_entity_death():
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.play("idle")
	sprite.process_mode = Node.PROCESS_MODE_DISABLED
	set_physics_process(false)
	set_process(false)

	for sm in _state_machines.values():
		sm.terminate()

	play_death_effect()

func get_attack_data() -> Dictionary:
	return ATTACK_DATA

func get_attack_hitbox_collision() -> CollisionShape2D:
	return attack_hitbox_collision

func take_damage(amount: int, knockback_dir: Vector2) -> void:
	var sm = get_state_machine(ENEMY_LAYER)
	if sm.current_state is EnemyRecoveryState:
		return # already in recovery, ignore hit (or handle i-frames)

	hit_points -= amount

	if hit_points <= 0:
		print("enemy dies")
		_on_entity_death()
		return

	# Set knockback — RecoveryState will drain this
	var dir_x = sign(global_position.x - knockback_dir.x)
	velocity = Vector2(dir_x * 50.0, -100.0)

	sm.notify(self , StateEvent.ENEMY_DAMAGED)

func play_death_effect():
	var GHOST_DURATION = 1.0
	var FLOAT_DISTANCE = 60.0

	var mat = ShaderMaterial.new()
	mat.shader = preload("res://resource/shader/ghost_death.gdshader")
	mat.set_shader_parameter("progress", 0.0)
	mat.set_shader_parameter("split_strength", 0.0)
	sprite.material = mat

	var tween = create_tween()
	tween.set_parallel(true)

	# shader progress: drives aberration + fade
	tween.tween_method(
		func(v):
			mat.set_shader_parameter("progress", v)
			mat.set_shader_parameter("split_strength", v * 0.03),
		0.0, 1.0, GHOST_DURATION
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# float upward in world space
	tween.tween_property(
		self , "position",
		position + Vector2(0, -FLOAT_DISTANCE),
		GHOST_DURATION
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.chain().tween_callback(queue_free)
