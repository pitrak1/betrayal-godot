extends "res://client/State.gd"

func enter(custom_data, testing=false):
	.enter(custom_data)
	if _host:
		$MenuPanel.set_title("Host Game")
		$StartButton.text = "Create"
	else:
		$MenuPanel.set_title("Join Game")
		$StartButton.text = "Join"
	$PlayerNameTextInput.setup("Player Name", 5, 15)
	$GameNameTextInput.setup("Game Name", 5, 15)
	$StartButton.connect("pressed", self, "on_StartButton_pressed")
	$BackButton.connect("pressed", self, "on_BackButton_pressed")
	
	if not testing:
		var peer = NetworkedMultiplayerENet.new()
		peer.create_client(_constants.ip_address, _constants.port)
		get_tree().network_peer = peer

func on_StartButton_pressed():
	emit_signal("log_string", "Handling on_StartButton_pressed...")
	_player_name = $PlayerNameTextInput.get_input_text()
	_game_name = $GameNameTextInput.get_input_text() 
	var player_name_validation = $PlayerNameTextInput.validate()
	var game_name_validation = $GameNameTextInput.validate()

	if player_name_validation and game_name_validation:
		if _host:
			emit_signal(
				"send_network_command", 
				"register_player_and_create_game", 
				{ 
					"player_name": _player_name, 
					"game_name": _game_name
				}
			)
		else:
			emit_signal(
				"send_network_command", 
				"register_player_and_join_game", 
				{ 
					"player_name": _player_name, 
					"game_name": _game_name
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
		$PlayerNameTextInput.set_validation_label("Name is already in use")
	elif data["status"] == "invalid_game_name":
		if _host:
			$GameNameTextInput.set_validation_label("Name is already in use")
		else:
			$GameNameTextInput.set_validation_label("Game does not exist")
	elif data["status"] == "success":
		emit_signal("change_state", "LobbyState", {
			"host": _host,
			"player_name": _player_name,
			"game_name": _game_name
		})
	
func on_BackButton_pressed():
	emit_signal("log_string", "Handling on_BackButton_pressed...")
	emit_signal("change_state", "MainMenuState", {})
