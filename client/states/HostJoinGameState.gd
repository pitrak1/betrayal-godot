extends "res://common/State.gd"

var host

func enter(custom_data):
	host = custom_data["host"]
	if host:
		$MenuPanel.set_title("Host Game")
	else:
		$MenuPanel.set_title("Join Game")
	$MenuPanel/PlayerNameTextInput.set_label("Player Name")
	$MenuPanel/GameNameTextInput.set_label("Game Name")
	$MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client("localhost", 8910)
	get_tree().network_peer = peer

func on_StartButton_pressed():
	$MenuPanel/PlayerNameTextInput.hide_validation_label()
	$MenuPanel/GameNameTextInput.hide_validation_label()
	var player_name = $MenuPanel/PlayerNameTextInput.get_input_text()
	emit_signal("send_network_command", "register_player", { "player_name": player_name })

func register_player_response(status):
	if status == "success":
		var game_name = $MenuPanel/GameNameTextInput.get_input_text()
		if host:
			emit_signal("send_network_command", "create_game", { "game_name": game_name })
		else:
			emit_signal("send_network_command", "join_game", { "game_name": game_name })
	else:
		$MenuPanel/PlayerNameTextInput.set_validation_label("Name is already in use")

func create_game_response(status):
	if status == "success":
		emit_signal("change_state", "LobbyState", {
			"player_name": $MenuPanel/PlayerNameTextInput.get_input_text(),
			"game_name": $MenuPanel/GameNameTextInput.get_input_text()
		})
	else:
		$MenuPanel/GameNameTextInput.set_validation_label("Name is already in use")
	
func on_BackButton_pressed():
	emit_signal("change_state", "MainMenuState", {})
