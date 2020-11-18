extends "res://common/State.gd"

var host
var player_name
var game_name

func enter(custom_data):
	custom_data = custom_data
	host = custom_data["host"]
	player_name = custom_data["player_name"]
	game_name = custom_data["game_name"]
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client("localhost", 8910)
	get_tree().network_peer = peer
	
	$MenuPanel.set_title(game_name)
	$MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")
	
func update_custom_data(custom_data):
	for i in range(6):
		var lobby_player = get_node("MenuPanel/LobbyPlayer" + str(i + 1))
		if i < custom_data["players"].values().size():
			lobby_player.set_player_name(custom_data["players"].values()[i]["player_name"])
			lobby_player.set_host_indicator(custom_data["players"].values()[i]["host"])
		else:
			lobby_player.clear_player_name()
			lobby_player.set_host_indicator(false)
			
			
func on_StartButton_pressed():
	pass
	
func on_BackButton_pressed():
	get_tree().network_peer = null
	emit_signal("change_state", "MainMenuState", {})
