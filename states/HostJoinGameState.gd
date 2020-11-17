extends "res://State.gd"

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

func on_StartButton_pressed():
	var peer = NetworkedMultiplayerENet.new()
	if host:
		peer.create_server(8910, 6)
	else:
		peer.create_client("localhost", 8910)
	get_tree().network_peer = peer
	
	var player_name = $MenuPanel/PlayerNameTextInput.get_input_text()
	var game_name = $MenuPanel/GameNameTextInput.get_input_text()
	var network_id = get_tree().get_network_unique_id()
	
	emit_signal("change_state", "LobbyState", { 
		"host": host, 
		"player_name": player_name,
		"game_name": game_name,
		"players": { network_id: { "player_name": player_name, "host": host } }
	})
	
func on_BackButton_pressed():
	emit_signal("change_state", "MainMenuState", {})
