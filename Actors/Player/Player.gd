extends KinematicBody2D

onready var animation = $AnimationPlayer
var velocity: = Vector2.ZERO
var speed: = Global.CELL * 4

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

# Projectile
export(String, FILE) var projectilePath
var Projectile
export var shootTimer: = 0.25

#player stats
var hp: = 4

func _ready() -> void:
	Projectile = load(projectilePath)
	$TimerCanShoot.wait_time = shootTimer

func _process(delta: float) -> void:
	debug_console(canShoot)

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			_move()
		SHOOT:
			_shoot()
					
	enter_state()
	
func _move() -> void:
	var playerInput: = get_player_input()
	velocity.x = playerInput.x * speed
	if playerInput.y == -1 and canJump:
		_jump()
	apply_gravity()
	velocity = move_and_slide(velocity, Vector2.UP)
	canJump = true if is_on_floor() else false
	isJumping = true if !is_on_floor() else false

func _shoot() -> void:
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
		
	if _input.x != 0: lastHorizontalInput = _input.x 
	
	if Input.is_action_pressed("shoot") and !isJumping:
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
			if velocity.x :  animation.play("Run")
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
	
		
func debug_console(message) -> void:
	pass
#	$Label.text = str(message)

func _on_TimerCanShoot_timeout() -> void:
	canShoot = true

func restart_timer() -> void:
	$TimerCanShoot.start()

func _on_PlayerHurtBox_area_entered(area: Area2D) -> void:
	print("hit by a mob")
	if hp > 0:
		hurt()
		hp -= 1
	else:
		die()

func hurt() -> void:
	pass

func die() -> void:
	print("player is dead")
	pass
