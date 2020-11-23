extends "res://common/State.gd"

func enter(custom_data):
	self.custom_data = custom_data
	emit_signal("log_string", "Entering CharacterConfirmationState...")
	$ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	emit_signal("send_network_command", "get_players", { "response_type": "return" })

func get_players_response(response):
	for player in response["players"]:
		$CharacterSelectionLabel.text += player["name"] + ": " + player["character_entry"]["display_name"] + "\n"
		
func on_ContinueButton_pressed():
	emit_signal("log_string", "Handling on_ContinueButton_pressed...")
	$WaitingLabel.visible = true
	emit_signal("send_network_command", "player_sync", {})
	
func player_sync_response(response):
	print("ON TO THE NEXT STATE!")
