extends "res://common/State.gd"

func enter(custom_data):
	self.custom_data = custom_data
	emit_signal("log_string", "Entering CharacterConfirmationState...")
	$ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	emit_signal("send_network_command", "get_character_selections", {})

func get_character_selections_response(response):
	for selection in response["selections"]:
		$CharacterSelectionLabel.text += selection["player_name"] + ": " + selection["character_name"] + "\n"
		
func on_ContinueButton_pressed():
	emit_signal("log_string", "Handling on_ContinueButton_pressed...")
	$WaitingLabel.visible = true
	emit_signal("send_network_command", "confirm_character_selections", {})
	
func confirm_character_selections_response(response):
	print("ON TO THE NEXT STATE!")
