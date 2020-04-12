extends KinematicBody2D

onready var animation = $AnimationPlayer
onready var hurtSound = $HurtSound
onready var invincibleTimer = $InvincibleTimer
var velocity: = Vector2.ZERO
var max_speed: = Global.CELL * 4
var acceleration: = 10.0
var friction: = 0.25

var jump: = Global.CELL * 7
var gravity: = Global.CELL * 20

# flags
var isJumping: bool
var canJump: bool
var canShoot: bool = true
var lastHorizontalInput: float = 1.0 # used in enter_state for flip sprite

### States
enum {
	MOVE,
	SHOOT,
	HURT,
	DEAD
}
var state = MOVE
### 
var hurtBy
# Projectile
export(String, FILE) var projectilePath
var Projectile
export var shootTimer: = 0.25

#player stats
var hp: = 30
var hitChoc: = 30 #on hit movement effect

func _ready() -> void:
	Projectile = load(projectilePath)
	$TimerCanShoot.wait_time = shootTimer

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			_move(delta)
		SHOOT:
			_shoot()
		HURT:
			_hurt()
					
	enter_state()
	
func _move(delta) -> void:	
	var playerInput: = get_player_input()
	#smooth acceleration
	if playerInput.x != 0:
		velocity.x += playerInput.x * acceleration 	
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	#smooth deceleration
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	#can the player jump?
	if playerInput.y == -1 and canJump:
		_jump()	
	#gravity
	apply_gravity()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#flags - is_on_floor should be tested after move_and_slide
	canJump = true if is_on_floor() else false
	isJumping = true if !is_on_floor() else false

func _shoot() -> void:
	#can shoot while jumping
	if isJumping:
		apply_gravity()		
		velocity.x = lerp(velocity.x, 0.0, friction / 4)#jump-shoot is mor slippy
		velocity = move_and_slide(velocity, Vector2.UP)		
	#canShoot toggled by timerCanSHoot
	if canShoot:		
		$ShootSound.play()
		var projectile = Projectile.instance()
		get_tree().get_root().add_child(projectile)
		projectile.global_position = $ProjectilePosition.global_position
		projectile.velocity *= lastHorizontalInput
		canShoot = false
		restart_timer()
	if Input.is_action_just_released("shoot"): state = MOVE
			
func get_player_input() -> Vector2:
	var _input: = Vector2.ZERO
	#horizontal
	if Input.is_action_pressed("left"):
		_input.x = -1		
	if Input.is_action_pressed("right"):
		_input.x = 1		
	#vertical
	if Input.is_action_just_pressed("jump"):
		_input.y = -1

	if _input != Vector2.ZERO: state = MOVE
		
	if _input.x != 0: lastHorizontalInput = _input.x #for flip_sprite
	
	if Input.is_action_pressed("shoot"): # and !isJumping: - uncomment if you like
		state = SHOOT # for animation - will check if can shoot after that
	return _input

func _jump() -> void:	
		velocity.y = -jump 
			
func apply_gravity() -> void:
	velocity.y += gravity * get_physics_process_delta_time()
	
func enter_state() -> void:	
	# manage animation
	match state:
		MOVE:
			if abs(velocity.x) > acceleration*2:  animation.play("Run")
			else: animation.play("Idle")
			if isJumping:  animation.play("Jump")
		SHOOT:
			animation.play("Shoot")	
			
	# FLip sprite // all states
	if lastHorizontalInput == 1: 
		$Sprite.flip_h = false
		$ProjectilePosition.position.x = 9
	else:
		$Sprite.flip_h = true
		$ProjectilePosition.position.x = -9
	
func _on_TimerCanShoot_timeout() -> void:
	canShoot = true

func restart_timer() -> void:
	$TimerCanShoot.start()

func _on_PlayerHurtBox_area_entered(area: Area2D) -> void:
	print("hit by a mob")
	if hp > 0:	
		hurtBy = area	
		state = HURT
		hp -= 1
	else:
		die()

func _hurt() -> void:
	velocity.x = (position.x - hurtBy.position.x) * hitChoc
	velocity = move_and_slide(velocity)
	hurtSound.play()
	$PlayerHurtBox/CollisionShape2D.disabled = true
	invincibleTimer.start()
	state = MOVE
		
func die() -> void:
	print("player is dead")
	pass
	
func _on_InvincibleTimer_timeout() -> void:
	$PlayerHurtBox/CollisionShape2D.disabled = false
