extends "res://client/State.gd"

func enter(custom_data):
	.enter(custom_data)
	$ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	emit_signal("send_network_command", "get_players", { "response_type": "return" })
	
func get_players_response(response):
	for player in response["players"]:
		$PlayerOrderLabel.text += player["name"] + ", "
	$PlayerOrderLabel.text = $PlayerOrderLabel.text.substr(0, $PlayerOrderLabel.text.length() - 2)
	
func on_ContinueButton_pressed():
	emit_signal("log_string", "Handling on_ContinueButton_pressed...")
	$WaitingLabel.visible = true
	emit_signal("send_network_command", "confirm_sync", {})
	
func confirm_sync_response(_response):
	emit_signal("change_state", "CharacterSelectionState", _custom_data)
