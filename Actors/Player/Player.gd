extends KinematicBody2D

onready var animation = $AnimationPlayer
var velocity: = Vector2.ZERO
var speed: = Global.CELL * 4

var jump: = Global.CELL * 400
var gravity: = Global.CELL * 20

# flags
var isJumping: bool
var canJump: bool

### States
enum {
	MOVE,
	HURT,
	DEAD
}

var state = MOVE
### 

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			_move()

func _move() -> void:
	var playerInput: = get_player_input()
	velocity.x = playerInput.x * speed
	if playerInput.y == -1 and canJump:
		jump()
	apply_gravity()
	velocity = move_and_slide(velocity, Vector2.UP)
	canJump = true if is_on_floor() else false
	animation_loop()
	isJumping = true if !is_on_floor() else false
		
func get_player_input() -> Vector2:
	var _input: = Vector2.ZERO
	#horizontal
	if Input.is_action_pressed("left"):
		_input.x = -1		
	if Input.is_action_pressed("right"):
		_input.x = 1
		$Sprite.flip_h = false					
	#vertical
	if Input.is_action_just_pressed("jump"):
		_input.y = -1
		
	return _input

func jump() -> void:	
	velocity.y = -jump * get_physics_process_delta_time() 
			
func apply_gravity() -> void:
	velocity.y += gravity * get_physics_process_delta_time()
	
func animation_loop() -> void:	
	if state == MOVE:
		if velocity.x :  animation.play("Run")
		else: animation.play("Idle")
		if isJumping: 	animation.play("Jump")
		$Sprite.flip_h = velocity.x < 0
	
