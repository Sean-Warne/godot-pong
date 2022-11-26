extends KinematicBody2D

export (int) var paddle_speed = 200
var screen_size
var velocity = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("up") and position.y > 25:
		velocity.y -= 1
	elif Input.is_action_pressed("down") and position.y < screen_size.y - 25:
		velocity.y += 1
	velocity = velocity.normalized() * paddle_speed

func _physics_process(delta):
	get_input()
	position += velocity * delta
	move_and_collide(velocity * delta)
