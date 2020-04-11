extends Area2D

onready var sfx = $AudioStreamPlayer

func _ready() -> void:
	$AnimatedSprite.play()

func _on_Collectible_body_entered(body: Node) -> void:
	sfx.play()
	yield(sfx, "finished")
	queue_free()
	
