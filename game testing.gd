extends Node2D
@export var Crab_scene:PackedScene
@export var spawn_location:Vector2
var screen_center = Vector2.ZERO
var screen_size = Vector2.ZERO
func start_game():
	screen_size = get_viewport_rect().size
	$Crab.set_physics_process(true)
	$Crab.visible = true
	$Crab.position = spawn_location
	$Camera2D.make_current()
	$Camera2D.position_smoothing_enabled = true
	#print($Crab.position)
	pass

func _process(delta):
	screen_center = $Camera2D.get_screen_center_position()
	var vMax = screen_center.y + (screen_size.y/2)
	var vMin = screen_center.y - (screen_size.y/2)
	var hMax = screen_center.x + (screen_size.x/2)
	var hMin = screen_center.x - (screen_size.x/2)
	
	$Crab.position.x = clamp($Crab.position.x,hMin,hMax)
	$Crab.position.y = clamp($Crab.position.y,vMin,vMax)
	if $Crab.position.x > screen_center.x:
		$Camera2D.position.x = $Crab.position.x - (screen_size.x/2)


func game_over():
	$HUD.game_over()

func send_score(score):
	$HUD.update_score(score)
