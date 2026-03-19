extends Area2D

@export var door_id: String
@export var target_door_id: String
@export var target_scene: String
@export var spawn_on_arrival: Vector2
@export var zone_name: String = ""

var near_player: bool = false
var player_ref: Node = null

func _ready() -> void:
    update_visuals()

    if door_id == "":
        push_error("[Door] Node has an empty door_id; this will cause GameState.doors lookups to fail.")
        return
    if not GameState.doors.has(door_id):
        GameState.doors[door_id] = false
    if target_door_id != "" and not GameState.doors.has(target_door_id):
        GameState.doors[target_door_id] = false

func _process(delta: float) -> void:
    if near_player and Input.is_action_just_pressed("use"):
        if GameState.doors.get(door_id, false):
            GameState.spawn_position = spawn_on_arrival
            GameState.zone_text = zone_name
            get_tree().change_scene_to_file(target_scene)

        elif GameState.hasKey:
            GameState.doors[door_id] = true

            if target_door_id != "":
                GameState.doors[target_door_id] = true

            update_visuals()

            GameState.hasKey = false
            GameState.door_unlocked.emit()

func update_visuals() -> void:
    $ColorRect.color = Color.GREEN if GameState.doors.get(door_id, false) else Color.RED

    if player_ref:
        player_ref.get_node("ThoughtBubble").show_message("Press E to enter")

func _on_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        near_player = true
        player_ref = body

        if GameState.doors.get(door_id, false):
            body.get_node("ThoughtBubble").show_message("Press E to enter")
        elif GameState.hasKey:
            body.get_node("ThoughtBubble").show_message("Press E to unlock")
        else:
            body.get_node("ThoughtBubble").show_message("This door is locked...")

func _on_body_exited(body: Node2D) -> void:
    if body.name == "Player":
        near_player = false
        player_ref = null

        body.get_node("ThoughtBubble").hide_message()
