extends RigidBody2D
signal _death_push
signal _attack
signal send_score()
var score = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walk")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#handles collision and stuff
func _on_hit_body_entered(body):
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


func _on_attack_body_entered(body):
	print(body)
	$mob_Timer.start()
	$AnimatedSprite2D.play("attack")
	emit_signal("_attack")
	await $mob_Timer.timeout
	$AnimatedSprite2D.play("walk")
	pass # Replace with function body.
