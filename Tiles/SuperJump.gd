extends Area2D

export var superJumpHeight: int = 15

func _on_SuperJump_area_entered(area: Area2D) -> void:
	if area.get_parent().velocity.y > Global.CELL * 15:
		$JumpSound.play()
		area.get_parent().velocity.x = 0.0
		area.get_parent().velocity.y = -Global.CELL * superJumpHeight
