extends KinematicBody2D

const INITIAL_SPEED = 200
const INITIAL_POSITION = Vector2(320, 200)

var screen_size
var velocity  = Vector2()
var ball_speed = INITIAL_SPEED

var left_score = 0
var right_score = 0
var bounces = 0

var rng = RandomNumberGenerator.new()

func reset():
	# reset ball
	rng.randomize()
	ball_speed = INITIAL_SPEED
	position   = Vector2(320, rng.randf_range(100, 300))
	velocity  = Vector2(-1, rng.randf_range(-.7, .7)) * ball_speed
	show()

func _ready():
	screen_size = get_viewport_rect().size
	
	get_parent().get_node("Button").visible = false
	get_parent().get_node("left_score").text = str(left_score)
	get_parent().get_node("right_score").text = str(right_score)
	get_parent().get_node("bounces").text = str(bounces)
	
	reset()

func _physics_process(delta):
	velocity = velocity.normalized() * ball_speed
	
	# top and bottom boundaries
	if position.y < 10 or position.y > screen_size.y - 10:
		velocity.y *= -1
	
	# paddle
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		ball_speed *= 1.2
		
		bounces += 1
		get_parent().get_node("bounces").text = str(bounces)
		
#		rng.randomize()
#		# move the ball in the direction the paddle is travelling
#		var paddle_velocity = get_parent().get_node("left_paddle").velocity.y
#		if paddle_velocity != 0:
#			velocity.y += (get_parent().get_node("left_paddle").velocity.y / 10)
#		else:
#			velocity.y *= rng.randf_range(-.7, .7)
#		velocity.x *= rng.randf_range(-.7, .7)

	# scoring
	if position.x < 0:
		right_score += 1
		get_parent().get_node("right_score").text = str(right_score)
		if right_score == 3:
			print("YOU LOSE")
			game_over()
		else:
			reset()
	elif position.x > 640:
		left_score += 1
		if left_score == 10:
			print("YOU WIN")
			game_over()
		else:
			reset()
		get_parent().get_node("left_score").text = str(left_score)
		reset()

func game_over():
	position = INITIAL_POSITION
	velocity = Vector2.ZERO
	get_parent().get_node("Button").visible = true

func _on_Button_pressed():
	get_parent().get_node("Button").visible = false
	
	right_score = 0
	left_score = 0
	bounces = 0
	get_parent().get_node("left_score").text = str(left_score)
	get_parent().get_node("right_score").text = str(right_score)
	get_parent().get_node("bounces").text = str(bounces)
	
	reset()
