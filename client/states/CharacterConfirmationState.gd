extends "res://common/State.gd"

var grid_scene = preload("res://common/Grid.tscn")
var player_scene = preload("res://common/Player.tscn")
var actor_scene = preload("res://common/Actor.tscn")
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
	var player_nodes = []
	for player_info in self.players:
		var player = player_scene.instance()
		player.setup(
			player_info["name"],
			player_info["host"],
			player_info["name"] == custom_data["player_name"],
			player_info["character_entry"]
		)
		grid.place_actor(player.actors[0], Vector2(0, 0))
	emit_signal("change_state", "TurnGameState", { "grid": grid, "players": player_nodes })
