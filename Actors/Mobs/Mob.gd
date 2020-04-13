extends Area2D

## animated sprite select
export(String, FILE) var spritePath
onready var anim = $AnimatedSprite

##select mob sfx
export(String, FILE) var sfxStreamPath
onready var mobSfx = $MobSfx

# movement
export var velocity: = Vector2.ZERO
export var speed: = 15
export var direction:float = -1.0

### Limit the deplacement distance left and right- in cell size - from the spawn point
var spawnPosition: Vector2
export var maxDistance: int = 2

# other export
export var health: int = 4

func _ready() -> void:
	maxDistance *= Global.CELL
	spawnPosition = position
	anim.frames = load(spritePath)
	anim.play()
	mobSfx.stream = load(sfxStreamPath)

func _physics_process(delta: float) -> void:
	move(delta)
	flip_anim(direction)

func move(delta) -> void:
	if position.x <= spawnPosition.x - maxDistance or position.x >= spawnPosition.x + maxDistance:
		direction = -direction
	velocity.x = direction
	position.x += velocity.x * speed * delta
		
func flip_anim(dir) -> void:
	if dir == 1:
		anim.flip_h = false
	else:
		anim.flip_h = true

func _on_Actor_body_entered(body: Node) -> void:
	#environment collision only (for mvnt direction) -- not hit/hurt box
	if body.is_in_group("Player"):
		return
	else:
		direction = -direction

func _on_area_entered(area: Area2D) -> void:	
	if health > 0:
		hurt_animation()
		if !area.is_in_group("Player"): # so its a projectile..
			health -= 1
	if health <= 0:
		die()

func hurt_animation() -> void:
	pass
	
func die() -> void:
	queue_free()

#mob sfx 
func _on_SfxTrigger_entered(area: Area2D) -> void:
	#player enter 
	mobSfx.play()

func _on_SfxTrigger_exited(area: Area2D) -> void:
	#in case of the sfx is on loop
	if mobSfx.playing == false:
		mobSfx.stop()
