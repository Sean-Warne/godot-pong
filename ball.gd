extends KinematicBody2D

const INITIAL_SPEED = 200
const INITIAL_POS = Vector2(320, 200)
var ball_speed = INITIAL_SPEED

var velocity = Vector2.ZERO

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _ready():
	pass

func _process(delta):
	velocity = Vector2(-1.0, 0)
	velocity = velocity.normalized() * ball_speed
	
	velocity = move_and_collide(velocity * delta)

func _on_VisibilityNotifier2D_screen_exited():
	
	start(INITIAL_POS)
