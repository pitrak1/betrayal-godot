extends "res://common/State.gd"

var host
var player_name
var game_name

func enter(custom_data):
	custom_data = custom_data
	host = custom_data["host"]
	player_name = custom_data["player_name"]
	game_name = custom_data["game_name"]
	
	$MenuPanel.set_title(game_name)
	$MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")
	
	emit_signal("send_network_command", "get_players", { "game_name": game_name })
	
func get_players_response(data):
	if data["status"] != "success":
		print("panic.")
	else:
		for i in range(6):
			var lobby_player = get_node("MenuPanel/LobbyPlayer" + str(i + 1))
			if i < data["players"].size():
				lobby_player.set_player_name(data["players"][i]["name"])
				lobby_player.set_host_indicator(data["players"][i]["host"])
			else:
				lobby_player.clear_player_name()
				lobby_player.set_host_indicator(false)
	
func on_StartButton_pressed():
	pass
	
func on_BackButton_pressed():
	get_tree().network_peer = null
	emit_signal("change_state", "MainMenuState", {})
