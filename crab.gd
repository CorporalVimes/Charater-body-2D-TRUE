extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health
var number_of_jumps
var is_head_squished

func _ready():
	number_of_jumps = 0
	self.set_physics_process(false)
	visible = false
	health = 1
	$AnimatedSprite2D.play("neutral")

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# double jump code
	# number of jumps is the number of extra jumps 
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if number_of_jumps >= 1:
			velocity.y = JUMP_VELOCITY
			number_of_jumps -=1
			is_head_squished = false #stops squished head multi jump
	if is_on_floor():
		number_of_jumps = 4
	
	#code for makeing sure the player needs to jump to break things
	if velocity.y < 0:
		$"Area2D".set_collision_layer_value(3,true)
	else:
		$"Area2D".set_collision_layer_value(3,false)
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move left", "move right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	

	
	#ANIMIMATIONS
	if is_head_squished == true:
		$AnimatedSprite2D.play("Squished")
		if is_on_floor():
				is_head_squished = false
	elif velocity.y < 0:
		$AnimatedSprite2D.play("jump")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("fall")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("neutral")
	
	
	move_and_slide()

func _on_area_2d_area_entered(_area):
	# only exist to make head squished when head bonked
	print("head squished")
	if not is_on_floor():
		is_head_squished = true
	pass # Replace with function body.


func _on_enemy__death_push():
	$stomp_timer.start()
	velocity.y = JUMP_VELOCITY
	$AnimatedSprite2D.set_animation("stomp")
	await $stomp_timer.timeout
	pass # Replace with function body.


func _on_enemy__attack():
	health-=1
	pass # Replace with function body.
