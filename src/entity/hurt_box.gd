extends Node2D

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("player_hitbox"):
        var dmg = area.damage
        var kb_dir = (global_position - area.global_position).normalized()
        owner.take_damage(dmg, kb_dir)
