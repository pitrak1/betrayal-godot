extends "res://client/State.gd"

func enter(custom_data):
	.enter(custom_data)
	
	$MenuPanel.set_title(_game_name)
	$MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")
	$MenuPanel/StartButton.visible = _host
	
	emit_signal("send_network_command", "get_players", {})
	
func get_players_response(data):
	for i in range(6):
		var lobby_player = get_node("MenuPanel/LobbyPlayer" + str(i + 1))
		if i < data["players"].size():
			lobby_player.set_player_name(data["players"][i]["name"])
			lobby_player.set_host_indicator(data["players"][i]["host"])
		else:
			lobby_player.clear_player_name()
			lobby_player.set_host_indicator(false)
	
func on_StartButton_pressed():
	emit_signal("send_network_command", "start_game", {})
	
func start_game_response(_data):
	emit_signal("change_state", "PlayerOrderState", _custom_data)
	
func on_BackButton_pressed(testing=false):
	if not testing:
		get_tree().network_peer = null
	emit_signal("change_state", "MainMenuState", {})
