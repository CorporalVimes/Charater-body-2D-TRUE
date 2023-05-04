extends CharacterBody2D

signal game_over
signal dead
const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health
var lives
var number_of_jumps
var is_head_squished
var is_start_fall
@export var is_actionable = false

func _ready():
	number_of_jumps = 0
	self.set_physics_process(false)
	visible = false
	is_actionable = false
	$AnimatedSprite2D.play("neutral")

func _physics_process(delta):
	
	#code to disable input in certian cases like spawning
	if is_start_fall:
		is_actionable = false
	if is_on_floor_only():
		is_actionable = true
		is_start_fall = false
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and is_actionable:
		velocity.y = JUMP_VELOCITY
	# double jump code
	# number of jumps is the number of extra jumps 
	if Input.is_action_just_pressed("jump") and not is_on_floor() and is_actionable:
		if number_of_jumps >= 1:
			velocity.y = JUMP_VELOCITY
			number_of_jumps -=1
			is_head_squished = false #stops squished head multi jump
	if is_on_floor():
		number_of_jumps = 4
	
	#code for makeing sure the player needs to jump to break things
	if velocity.y != 0:
		$"Area2D".set_collision_layer_value(3,true)
	else:
		$"Area2D".set_collision_layer_value(3,false)
	


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("move left", "move right")
	if direction and is_actionable:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _process(delta):
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


#PUSHES PLAYER AWAY AFTER KILLING EMENY
func _on_enemy__death_push():
	$player_timer.start()
	velocity.y = JUMP_VELOCITY
	self.set_physics_process(false)
	self.set_process(false)
	is_head_squished = false
	$AnimatedSprite2D.set_animation("stomp")
	await $player_timer.timeout
	self.set_physics_process(true)
	self.set_process(true)
	pass # Replace with function body.

func _death():
	if not lives < 0:
		emit_signal("dead")
	else:
		emit_signal("game_over")

#FUNC FOR WHEN PLAYER *GETS* ATTACKED
func _attack(direction):
	print(velocity.x)
	health-=1
	$player_timer.start()
	self.set_physics_process(false)
	self.set_process(false)
	is_actionable = false
	$AnimatedSprite2D.play("hurt")
	velocity= Vector2(-2500,-1)
	await $player_timer.timeout
	if health > 0:
		self.set_physics_process(true)
		$AnimatedSprite2D.play("hurt_pushback")
		$player_timer.start()
		await $player_timer.timeout
		self.set_process(true)
		is_actionable = true
	else:
		_death()
	#iewport = get_viewport()
	#iewport.
	

	print(velocity.x)
	pass # Replace with function body.


func _on_head_squish_area_entered(area):
	# only exist to make head squished when head bonked
	print("head squished")
	if not is_on_floor():
		is_head_squished = true
	pass # Replace with function body.
