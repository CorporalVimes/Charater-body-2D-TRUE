extends Node2D
@export var Crab_scene:PackedScene
var screen_center = Vector2.ZERO
var screen_size = Vector2.ZERO
var _should_clamp = false

func start_game():
	screen_size = get_viewport_rect().size
	$Crab.call_deferred("_start_game")
	$Crab.position = $spawn_point.position
	$Crab.set_deferred("lives", 3)
	$Camera2D.make_current()
	$Camera2D.position_smoothing_enabled = true
	$Camera2D.position = Vector2.ZERO
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
	$Crab.call_deferred("_start_game")
	$Crab.position = $spawn_point.position
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
