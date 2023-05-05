extends Node2D
@export var Crab_scene:PackedScene
var screen_center = Vector2.ZERO
var screen_size = Vector2.ZERO
var _should_clamp = false
var defalt_health = 2
func start_game():
	screen_size = get_viewport_rect().size
	$Crab.set_physics_process(true)
	$Crab.set_process(true)
	$Crab.visible = true
	$Crab.set_deferred("is_actionable",true)
	$Crab.set_deferred("health", defalt_health)
	$Crab.set_deferred("lives", 3)
	$Crab.position = $spawn_point.position
	$Camera2D.make_current()
	$Camera2D.position_smoothing_enabled = true
	$Camera2D.position = Vector2.ZERO
	$Crab/AnimatedSprite2D.play("neutral")
	$Crab.set_deferred("is_start_fall", true)
	_should_clamp = true
	print($Crab.position)
	

func _process(delta):
	screen_center = $Camera2D.get_screen_center_position()
	var hMax = screen_center.x + (screen_size.x/2)
	var hMin = screen_center.x - (screen_size.x/2)
	if _should_clamp:
		$Crab.position.x = clamp($Crab.position.x,hMin,hMax)
		if $Crab.position.x > screen_center.x:
			$Camera2D.position.x = $Crab.position.x - (screen_size.x/2)


func game_over():
	$HUD.game_over()

func send_score(score):
	$HUD.update_score(score)


func _reset_game():
	$Crab.set_deferred("health", defalt_health)
	$Crab.set_physics_process(true)
	$Crab.set_process(true)
	$Crab.visible = true
	$Crab/AnimatedSprite2D.play("neutral")
	$Crab.position = $spawn_point.position
	$Crab.call_deferred("move_and_slide")
	$Crab.is_start_fall = true
	$Crab/player_timer.start()
	await $Crab/player_timer.timeout
	_should_clamp = true
	$Camera2D.position_smoothing_enabled = true
	print($Camera2D.position)
	print($Crab.position)

func _on_crab_dead():
	$Camera2D.position.x = 0
	_should_clamp = false
	$Camera2D.position_smoothing_enabled = false
	_reset_game()
	pass # Replace with function body.
