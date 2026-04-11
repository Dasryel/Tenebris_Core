class_name KeyColors

static var colors: Dictionary = {}

static func get_color(key_id: String) -> Color:
    if colors.is_empty():
        _init_colors()
    return colors.get(key_id, Color.WHITE)

static func _init_colors() -> void:
    colors = {
        "red_key": Color(0.75, 0.20, 0.20, 1.0),
        "blue_key": Color(0.20, 0.35, 0.75, 1.0),
        "orange_key": Color(0.80, 0.40, 0.15, 1.0),
        "yellow_key": Color(0.75, 0.65, 0.20, 1.0),
    }
