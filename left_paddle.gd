extends KinematicBody2D

export (int) var paddle_speed = 200
var screen_size

var velocity = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	elif Input.is_action_pressed("down"):
		velocity.y += 1
	velocity = velocity.normalized() * paddle_speed

func _process(delta):
	get_input()
	
	position += velocity * delta
	position.y = clamp(position.y, 0, screen_size.y)
	
	velocity = move_and_collide(velocity * delta)
