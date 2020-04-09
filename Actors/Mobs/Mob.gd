extends Area2D

## animated sprite select
export(String, FILE) var spritePath
onready var anim = $AnimatedSprite

# movement
export var velocity: = Vector2.ZERO
export var speed: = 15
export var direction:float = -1.0

# other export
export var health: int

func _ready() -> void:
	anim.frames = load(spritePath)
	anim.play()

func _physics_process(delta: float) -> void:
	move(delta)
	flip_anim(direction)

func move(delta) -> void:
	velocity.x = direction
	position.x += velocity.x * speed * delta
		
func flip_anim(dir) -> void:
	if dir == 1:
		anim.flip_h = false
	else:
		anim.flip_h = true

func _on_Actor_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("player")
	else:
		direction = -direction
	
