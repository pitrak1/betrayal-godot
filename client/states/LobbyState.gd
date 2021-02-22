extends "res://client/State.gd"

func _ready():
	$UICanvasLayer/MenuPanel.set_title(_global_context.player_info["game_name"])
	$UICanvasLayer/MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$UICanvasLayer/MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")
	$UICanvasLayer/MenuPanel/StartButton.visible = _global_context.player_info["host"]
	send_network_command("get_players", {})
	
func get_players_response(data):
	_log("Handling get_players_response with status " + data["status"] + "...")
	for i in range(6):
		var lobby_player = get_node("UICanvasLayer/MenuPanel/LobbyPlayer" + str(i + 1))
		if i < data["players"].size():
			lobby_player.set_player_name(data["players"][i]["name"])
			lobby_player.set_host_indicator(data["players"][i]["host"])
		else:
			lobby_player.clear_player_name()
			lobby_player.set_host_indicator(false)
	
func on_StartButton_pressed():
	_log("Handling StartButton pressed...")
	send_network_command("start_game", {})
	
func start_game_response(data):
	_log("Handling start_game_response with status " + data["status"] + "...")
	_state_machine.goto_scene("res://client/states/PlayerOrderState.tscn")
	
func on_BackButton_pressed():
	_state_machine.goto_scene("res://client/states/MainMenuState.tscn")
