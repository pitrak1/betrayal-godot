extends "res://State.gd"

var host

func enter(custom_data):
	host = custom_data["host"]
	if host:
		$MenuPanel.set_title("Host Game")
	else:
		$MenuPanel.set_title("Join Game")
	$MenuPanel/PlayerNameTextInput.set_label("Player Name")
	$MenuPanel/GameNameTextInput.set_label("Game Name")
	$MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")

func on_StartButton_pressed():
	print($MenuPanel/PlayerNameTextInput.get_input_text())
	print($MenuPanel/GameNameTextInput.get_input_text())
	
func on_BackButton_pressed():
	emit_signal("change_state", "MainMenuState", {})
