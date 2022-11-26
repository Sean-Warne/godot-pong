extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500

export (int) var paddle_speed = 100

var ball_pos
var follow_speed
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

onready var screen_size = get_viewport_rect().size

func _ready():
	pass

func move(delta):
	input_vector = Vector2.ZERO
	ball_pos = get_parent().get_node("ball").position
	
	if position.x - ball_pos.x < 400:
		follow_speed = 10
	else:
		follow_speed = 50
	
	if position.y > ball_pos.y + 5 and position.y > 25:
		input_vector.y -= 1
	elif position.y < ball_pos.y - 5 and position.y < screen_size.y - 25:
		input_vector.y += 1
	
	input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * paddle_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func _physics_process(delta):
	move(delta)
	position += velocity * delta
	move_and_collide(velocity * delta)
