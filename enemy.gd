extends CharacterBody2D
signal _death_push
signal _attack()
signal send_score()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1
var speed = 200
var score = 500
var _was_on_wall = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walk")
	self.set_physics_process(true)


func _physics_process(delta):
	
		#now with new GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x += speed * delta * direction
	if is_on_wall() and not _was_on_wall:
		direction *= -1
		_was_on_wall = true
	else:
		_was_on_wall = false
	move_and_slide()

func _on_attack_body_entered(body):
	print(body)
	$mob_Timer.start()
	$AnimatedSprite2D.play("attack")
	emit_signal("_attack")
	$hit/CollisionShape2D.set_deferred("disabled",true)
	self.set_physics_process(false)
	await $mob_Timer.timeout
	self.set_physics_process(true)
	$hit/CollisionShape2D.set_deferred("disabled",false)
	$AnimatedSprite2D.play("walk")
	pass # Replace with function body.

#handles collision and stuff
func _on_hit_area_entered(area):
	emit_signal("_death_push")
	emit_signal("send_score",score)
	$mob_Timer.start()
	self.set_deferred("freeze",true)
	$CollisionShape2D.set_deferred("disabled", true)
	$hit/CollisionShape2D.set_deferred("disabled", true)
	self.call_deferred("set_physics_process", false)
	$AnimatedSprite2D.play("death")
	await $mob_Timer.timeout
	queue_free()
	pass # Replace with function body.

