extends "res://client/State.gd"

const __grid_scene = preload("res://common/Grid.tscn")
const __player_scene = preload("res://common/Player.tscn")
const __actor_scene = preload("res://common/Actor.tscn")
var __players

func enter(custom_data):
	.enter(custom_data)
	$ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	emit_signal(
		"send_network_command", 
		"get_players", 
		{ "response_type": "return" }
	)

func get_players_response(response):
	__players = response["players"]
	for player in response["players"]:
		$CharacterSelectionLabel.text += player["name"] + ": " \
			+ player["character_entry"]["display_name"] + "\n"
		
func on_ContinueButton_pressed():
	emit_signal("log_string", "Handling on_ContinueButton_pressed...")
	$WaitingLabel.visible = true
	emit_signal("send_network_command", "confirm_sync", {})
	
func confirm_sync_response(_response):
	emit_signal("log_string", "Handling confirm_sync_response...")
	var grid = __grid_scene.instance()
	grid.setup()
	var player_nodes = []
	for player_info in __players:
		var player = __player_scene.instance()
		player.setup(
			player_info["name"],
			player_info["host"],
			player_info["character_entry"],
			player_info["name"] == _custom_data["player_name"]
		)
		grid.place_actor(player.get_primary_actor(), Vector2(0, 0))
	emit_signal(
		"change_state", 
		"TurnGameState", 
		{ "grid": grid, "players": player_nodes }
	)
