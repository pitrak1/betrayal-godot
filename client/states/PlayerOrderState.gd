extends "res://client/State.gd"

func _ready():
	$UICanvasLayer/ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	send_network_command("get_players", { "response_type": "return" })
	
func get_players_response(response):
	for player in response["players"]:
		$UICanvasLayer/PlayerOrderLabel.text += player["name"] + ", "
	$UICanvasLayer/PlayerOrderLabel.text = $UICanvasLayer/PlayerOrderLabel.text.substr(0, $UICanvasLayer/PlayerOrderLabel.text.length() - 2)
	
func on_ContinueButton_pressed():
	_log("Handling ContinueButton pressed...")
	$UICanvasLayer/WaitingLabel.visible = true
	send_network_command("confirm_sync", {})
	
func confirm_sync_response(_response):
	_state_machine.goto_scene("res://client/states/CharacterSelectionState.tscn")
