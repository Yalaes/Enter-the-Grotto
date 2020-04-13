extends Area2D

onready var sfx = $AudioStreamPlayer
var playerPickupKey: bool = false

func _ready() -> void:
	$AnimationPlayer.play("Idle")

func _on_Key_body_entered(body: Node) -> void:
	sfx.play()
	Game.playerHasTheKey = true
	yield(sfx, "finished")
	queue_free()

