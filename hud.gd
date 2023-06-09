extends CanvasLayer
signal start_game
var current_score = 0
func _ready():
	$score.hide()

func update_score(score):
	current_score += score
	$score.text = str(current_score)

func show_message(text):
	$messageLabel.text = text
	$messageLabel.show()

func game_over():
	$messageLabel.show()
	$messageLabel.text = "game over"

func _death_info(lives):
	$death_screen.text = "B - " + str(lives)

func _on_button_pressed():
	$Button.hide()
	$messageLabel.hide()
	$score.show()
	emit_signal("start_game")
	pass # Replace with function body.
