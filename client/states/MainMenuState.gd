extends "res://common/State.gd"

func enter(custom_data):
	$MenuPanel/HostButton.connect("pressed", self, "on_HostButton_pressed")
	$MenuPanel/JoinButton.connect("pressed", self, "on_JoinButton_pressed")
	$MenuPanel/ExitButton.connect("pressed", self, "on_ExitButton_pressed")

func on_HostButton_pressed():
	emit_signal("change_state", "HostJoinGameState", { 'host': true })
	
func on_JoinButton_pressed():
	emit_signal("change_state", "HostJoinGameState", { 'host': false })
	
func on_ExitButton_pressed():
	get_tree().quit()
