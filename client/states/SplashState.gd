extends "res://client/State.gd"

func enter(custom_data):
	.enter(custom_data)
	$MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")

func on_StartButton_pressed():
	emit_signal("log_string", "Handling on_StartButton_pressed...")
	emit_signal("change_state", "MainMenuState", {})
