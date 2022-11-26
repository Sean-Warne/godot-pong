extends KinematicBody2D

const INITIAL_SPEED = 200
const INITIAL_POSITION = Vector2(320, 200)
const SPEED_INCREMENT = 50
const DIRECTION_X = [-1, 1]
const SCORE_LIMIT = 10

var screen_size
var velocity  = Vector2()
var ball_speed = INITIAL_SPEED

var left_score = 0
var right_score = 0
var bounces = 0

var rng = RandomNumberGenerator.new()

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
		rng.randomize()
		
		# move the ball in the direction the paddle is travelling
		var paddle_velocity = get_parent().get_node("left_paddle").velocity.y
		if paddle_velocity != 0:
			velocity.y += (get_parent().get_node("left_paddle").velocity.y / 10)
		else:
			velocity.y += rng.randf_range(-1, 1)
			
		velocity.x *= -1
		
		print("(x=" + str(velocity.x) + ", y=" + str(velocity.y) + ")")
		
		ball_speed += SPEED_INCREMENT
		
		set_bounces(bounces + 1)

	# scoring
	if position.x < 0:
		right_score += 1
		get_parent().get_node("right_score").text = str(right_score)
		if right_score == SCORE_LIMIT:
			print("YOU LOSE")
			game_over()
		else:
			reset()
	elif position.x > 640:
		left_score += 1
		if left_score == SCORE_LIMIT:
			print("YOU WIN")
			game_over()
		else:
			reset()
		get_parent().get_node("left_score").text = str(left_score)
		reset()

func reset():
	# reset ball
	print("RESET")
	rng.randomize()
	ball_speed = INITIAL_SPEED
	position   = Vector2(320, rng.randf_range(100, 300))
	velocity  = Vector2(
			DIRECTION_X[randi() % DIRECTION_X.size()],
			rng.randf_range(-.7, .7)
		) * ball_speed
	set_bounces(0)
	show()

func set_score(left_or_right, value):
	if left_or_right == "left":
		left_score = value
		get_parent().get_node("left_score").text = str(left_score)
	elif left_or_right == "right":
		right_score = value
		get_parent().get_node("right_score").text = str(right_score)

func set_bounces(value):
	bounces = value
	get_parent().get_node("bounces").text = str(bounces)
	
	# set high score bounces
	if bounces > int(get_parent().get_node("bounces_high").text):
		get_parent().get_node("bounces_high").text = str(bounces)

func game_over():
	position = INITIAL_POSITION
	velocity = Vector2.ZERO
	get_parent().get_node("Button").visible = true

func _on_Button_pressed():
	get_parent().get_node("Button").visible = false
	set_score("left", 0)
	set_score("right", 0)
	set_bounces(0)
	reset()
