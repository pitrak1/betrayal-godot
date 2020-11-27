extends "res://common/State.gd"

var host
var player_name
var game_name

func enter(custom_data):
	self.custom_data = custom_data
	emit_signal("log_string", "Entering HostJoinGameState...")
	host = custom_data["host"]
	
	if host:
		$MenuPanel.set_title("Host Game")
		$MenuPanel/StartButton.text = "Create"
	else:
		$MenuPanel.set_title("Join Game")
		$MenuPanel/StartButton.text = "Join"
	$MenuPanel/PlayerNameTextInput.setup("Player Name", 5, 15)
	$MenuPanel/GameNameTextInput.setup("Game Name", 5, 15)
	$MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client("localhost", 8910)
	get_tree().network_peer = peer

func on_StartButton_pressed():
	emit_signal("log_string", "Handling on_StartButton_pressed...")
	player_name = $MenuPanel/PlayerNameTextInput.get_input_text()
	game_name = $MenuPanel/GameNameTextInput.get_input_text() 
	var player_name_validation = $MenuPanel/PlayerNameTextInput.validate()
	var game_name_validation = $MenuPanel/GameNameTextInput.validate()
	
	
	if player_name_validation and game_name_validation:
		if host:
			emit_signal(
				"send_network_command", 
				"register_player_and_create_game", 
				{ 
					"player_name": player_name, 
					"game_name": game_name
				}
			)
		else:
			emit_signal(
				"send_network_command", 
				"register_player_and_join_game", 
				{ 
					"player_name": player_name, 
					"game_name": game_name
				}
			)
		
func register_player_and_create_game_response(data):
	emit_signal("log_string", "Handling register_player_and_create_game_response with status " + data["status"] + "...")
	__response(data)
	
func register_player_and_join_game_response(data):
	emit_signal("log_string", "Handling register_player_and_join_game_response with status " + data["status"] + "...")
	__response(data)
	
func __response(data):
	if data["status"] == "invalid_player_name":
		$MenuPanel/PlayerNameTextInput.set_validation_label("Name is already in use")
	elif data["status"] == "invalid_game_name":
		if host:
			$MenuPanel/GameNameTextInput.set_validation_label("Name is already in use")
		else:
			$MenuPanel/GameNameTextInput.set_validation_label("Game does not exist")
	elif data["status"] == "success":
		emit_signal("change_state", "LobbyState", {
			"host": host,
			"player_name": player_name,
			"game_name": game_name
		})
	
func on_BackButton_pressed():
	emit_signal("log_string", "Handling on_BackButton_pressed...")
	emit_signal("change_state", "MainMenuState", {})
