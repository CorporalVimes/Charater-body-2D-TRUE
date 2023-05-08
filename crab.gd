extends CharacterBody2D

signal game_over
signal dead
const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health
var defalt_health = 2
var lives
var number_of_jumps
var is_head_squished
var is_start_fall
var xdirection = 1
@export var is_actionable = false

func _ready():
	number_of_jumps = 0
	self.set_physics_process(false)
	visible = false
	is_actionable = false
	lives = 3
	$AnimatedSprite2D.play("neutral")

func _start_game():
	self.set_physics_process(true)
	self.set_process(true)
	self.visible = true
	self.set_deferred("is_actionable",true)
	self.set_deferred("health", defalt_health)
	$AnimatedSprite2D.play("neutral")
	self.call_deferred("move_and_slide")
	self.is_start_fall = true
	pass

func _physics_process(delta):
	
	#code to disable input in certian cases like spawning
	if is_start_fall:
		is_actionable = false
	if is_on_floor_only() and is_start_fall == true:
		is_actionable = true
		is_start_fall = false
	
	if velocity.x > 0:
		xdirection = 1
	elif velocity.x < 0:
		xdirection = -1
	
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
	lives -= 1
	if not lives < 0:
		emit_signal("dead")
		
		print(lives)
		print(health)
	else:
		emit_signal("game_over")

#FUNC FOR WHEN PLAYER *GETS* ATTACKED
func _attack():
	print(xdirection)
	health-=1
	$player_timer.start()
	self.set_physics_process(false)
	self.set_process(false)
	is_actionable = false
	$AnimatedSprite2D.play("hurt")
	await $player_timer.timeout
	if health > 0:
		velocity= Vector2(-2500 * xdirection,-1)
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
	
	pass # Replace with function body.


func _on_head_squish_area_entered(area):
	# only exist to make head squished when head bonked
	print("head squished")
	if not is_on_floor():
		is_head_squished = true
	pass # Replace with function body.
