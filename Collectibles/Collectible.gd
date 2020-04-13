extends Area2D

onready var sfx = $AudioStreamPlayer
onready var animatedSprite = $AnimatedSprite

func _ready() -> void:
	animatedSprite.play()

func _on_Collectible_body_entered(body: Node) -> void:
	sfx.play()
	yield(sfx, "finished")
	queue_free()
	
