extends CharacterBody2D

## The player character

## The maximum velocity of the character
const MAX_VEL = 100.0
## Multiplier when lerping to zero
const STOP_MULT = 0.3
## Multiplier when lerping to the maximum velocity
const GO_MULT = 0.2

func _ready():
	pass # Replace with function body.



func _process(delta):
	if Input.is_action_pressed("up") and not Input.is_action_pressed("down"):
		velocity.y = lerp(velocity.y, -MAX_VEL * delta*60.0, GO_MULT)
	elif Input.is_action_pressed("down") and not Input.is_action_pressed("up"):
		velocity.y = lerp(velocity.y, MAX_VEL * delta*60.0, GO_MULT)
	else:
		velocity.y = lerp(velocity.y, 0.0, STOP_MULT)
	
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, -MAX_VEL * delta*60.0, GO_MULT)
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		velocity.x = lerp(velocity.x, MAX_VEL * delta*60.0, GO_MULT)
	else:
		velocity.x = lerp(velocity.x, 0.0, STOP_MULT)
	
	
func _physics_process(delta) -> void:
	move_and_slide()
