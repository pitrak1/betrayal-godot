extends "res://common/State.gd"

var grid_scene = preload("res://common/Grid.tscn")
var players

func enter(custom_data):
	self.custom_data = custom_data
	emit_signal("log_string", "Entering CharacterConfirmationState...")
	$ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	emit_signal("send_network_command", "get_players", { "response_type": "return" })

func get_players_response(response):
	self.players = response["players"]
	for player in response["players"]:
		$CharacterSelectionLabel.text += player["name"] + ": " + player["character_entry"]["display_name"] + "\n"
		
func on_ContinueButton_pressed():
	emit_signal("log_string", "Handling on_ContinueButton_pressed...")
	$WaitingLabel.visible = true
	emit_signal("send_network_command", "confirm_sync", {})
	
func confirm_sync_response(response):
	emit_signal("log_string", "Handling confirm_sync_response...")
	var grid = grid_scene.instance()
	grid.setup()
	emit_signal("change_state", "TurnGameState", { "grid": grid })
