extends "res://client/State.gd"

var __player_name
var __game_name

func _ready():
	if _global_context.player_info["host"]:
		$UICanvasLayer/MenuPanel.set_title("Host Game")
		$UICanvasLayer/MenuPanel/StartButton.text = "Create"
	else:
		$UICanvasLayer/MenuPanel.set_title("Join Game")
		$UICanvasLayer/MenuPanel/StartButton.text = "Join"
	$UICanvasLayer/MenuPanel/PlayerNameTextInput.setup("Player Name", 5, 15)
	$UICanvasLayer/MenuPanel/GameNameTextInput.setup("Game Name", 5, 15)
	$UICanvasLayer/MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$UICanvasLayer/MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")

func on_StartButton_pressed():
	_log("Handling StartButton pressed...")
	__player_name = $UICanvasLayer/MenuPanel/PlayerNameTextInput.get_input_text()
	__game_name = $UICanvasLayer/MenuPanel/GameNameTextInput.get_input_text() 
	var player_name_validation = $UICanvasLayer/MenuPanel/PlayerNameTextInput.validate()
	var game_name_validation = $UICanvasLayer/MenuPanel/GameNameTextInput.validate()

	if player_name_validation and game_name_validation:
		if _global_context.player_info["host"]:
			send_network_command("register_player_and_create_game", {
				"player_name": __player_name, 
				"game_name": __game_name
			})
		else:
			send_network_command("register_player_and_join_game", {
				"player_name": __player_name, 
				"game_name": __game_name
			})
		
func register_player_and_create_game_response(data):
	_log("Handling register_player_and_create_game_response with status " + data["status"] + "...")
	__response(data)
	
func register_player_and_join_game_response(data):
	_log("Handling register_player_and_join_game_response with status " + data["status"] + "...")
	__response(data)
	
func __response(data):
	if data["status"] == "invalid_player_name":
		$UICanvasLayer/MenuPanel/PlayerNameTextInput.set_validation_label("Name is already in use")
	elif data["status"] == "invalid_game_name":
		if _global_context.player_info["host"]:
			$UICanvasLayer/MenuPanel/GameNameTextInput.set_validation_label("Name is already in use")
		else:
			$UICanvasLayer/MenuPanel/GameNameTextInput.set_validation_label("Game does not exist")
	elif data["status"] == "success":
		_global_context.player_info["player_name"] = __player_name
		_global_context.player_info["game_name"] = __game_name
		_state_machine.goto_scene("res://client/states/LobbyState.tscn")
	
func on_BackButton_pressed():
	_log("Handling BackButton pressed...")
	_state_machine.goto_scene("res://client/states/MainMenuState.tscn")
