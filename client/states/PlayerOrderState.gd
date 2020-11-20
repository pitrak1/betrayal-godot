extends "res://common/State.gd"

func enter(custom_data):
	self.custom_data = custom_data
	emit_signal("log_string", "Entering PlayerOrderState...")
	$ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	emit_signal("send_network_command", "get_player_order", {})
	
func get_player_order_response(response):
	for player in response["player_names"]:
		$PlayerOrderLabel.text += player + ", "
	$PlayerOrderLabel.text = $PlayerOrderLabel.text.substr(0, $PlayerOrderLabel.text.length() - 2)
	
func on_ContinueButton_pressed():
	emit_signal("log_string", "Handling on_ContinueButton_pressed...")
	$WaitingLabel.visible = true
	emit_signal("send_network_command", "confirm_player_order", {})
	
func confirm_player_order_response(response):
	emit_signal("change_state", "CharacterSelectionState", custom_data)
