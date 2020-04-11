extends Area2D


export var velocity: float
export(String, FILE) var texturePath
onready var animation = $AnimationPlayer
onready var sfx = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = load(texturePath)
	animation.play("Idle")
	
func _physics_process(delta: float) -> void:
	position.x += velocity * delta
	flip_anim()


func flip_anim() -> void:
	if velocity > 0 :
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func _on_body_entered(body: Node) -> void:
	when_hitting_something()
	
func _on_Projectile_area_entered(area: Area2D) -> void:
	when_hitting_something()

func when_hitting_something() -> void:
	sfx.play()
	animation.play("Collide")
	set_physics_process(false)
	
func _on_screen_exited() -> void:
	queue_free()

