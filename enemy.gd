extends CharacterBody2D
signal _death_push
signal _attack()
signal send_score()
var direction = -1
var speed = 50000
var score = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walk")

func _process(delta):
	velocity.x = speed * delta * direction
	print(velocity)
	pass

func _on_attack_body_entered(body):
	print(body)
	$mob_Timer.start()
	$AnimatedSprite2D.play("attack")
	emit_signal("_attack")
	$hit/CollisionShape2D.set_deferred("disabled",true)
	await $mob_Timer.timeout
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
	$AnimatedSprite2D.play("death")
	await $mob_Timer.timeout
	queue_free()
	pass # Replace with function body.


func _on_walk_timer_timeout():

	pass # Replace with function body.
