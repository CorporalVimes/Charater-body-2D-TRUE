extends RigidBody2D
signal _death_push
signal _attack()
signal send_score()
var direction
var score = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walk")
	direction = -1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_body_entered(body):
	print(body)
	$mob_Timer.start()
	$AnimatedSprite2D.play("attack")
	emit_signal("_attack",direction)
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
