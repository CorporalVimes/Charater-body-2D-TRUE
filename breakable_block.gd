extends AnimatableBody2D
signal send_score()
var score = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_node("Break timer")
	timer.timeout.connect(_on_Timer_timeout)
	$AnimatedSprite2D.play("Normal")
	pass # Replace with function body.

func _on_Timer_timeout():
		#print("kill")
		
		queue_free()
		pass
	

func _on_area_2d_area_entered(area):
	# code to make block break
	$AnimatedSprite2D.play("Break")
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	$CollisionShape2D.set_deferred("disabled",true)
	emit_signal("send_score",score)
	$"Break timer".start()
	#print("True!")
	#print(area)
	pass # Replace with function body.
