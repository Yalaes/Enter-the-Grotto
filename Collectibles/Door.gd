extends Area2D

func _on_Door_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		area.get_parent().can_exit_level()
