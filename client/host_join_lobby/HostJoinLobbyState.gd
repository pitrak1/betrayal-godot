extends "res://client/State.gd"

var __player_name
var __game_name
const __text_validator_script = preload("res://common/Textvalidator.gd")
var __text_validator

func _ready():
	__text_validator = __text_validator_script.new()
	
	$UICanvasLayer/MenuPanel/PlayerNameTextInput.set_label("Player Name")
	$UICanvasLayer/MenuPanel/GameNameTextInput.set_label("Game Name")
	if _global_context.player_info["host"]:
		$UICanvasLayer/MenuPanel.set_title("Host Game")
		$UICanvasLayer/MenuPanel/StartButton.text = "Create"
	else:
		$UICanvasLayer/MenuPanel.set_title("Join Game")
		$UICanvasLayer/MenuPanel/StartButton.text = "Join"
	
	$UICanvasLayer/MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")
	$UICanvasLayer/MenuPanel/BackButton.connect("pressed", self, "on_BackButton_pressed")

func on_StartButton_pressed():
	__player_name = $UICanvasLayer/MenuPanel/PlayerNameTextInput.get_input_text()
	__game_name = $UICanvasLayer/MenuPanel/GameNameTextInput.get_input_text()
	var player_name_validation = __text_validator.player_name_validator(__player_name)
	var game_name_validation = __text_validator.game_name_validator(__player_name, _global_context.player_info["host"])
	
	$UICanvasLayer/MenuPanel/PlayerNameTextInput.set_validation_label(player_name_validation)
	$UICanvasLayer/MenuPanel/PlayerNameTextInput.set_validation_label(player_name_validation)

	if not player_name_validation and not game_name_validation:
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
	__response(data)
	
func register_player_and_join_game_response(data):
	__response(data)
	
func __response(data):
	if data["status"] == "player_name_taken":
		$UICanvasLayer/MenuPanel/PlayerNameTextInput.set_validation_label(data["status"])
	elif data["status"] == "game_name_taken" or data["status"] == "game_not_found":
		$UICanvasLayer/MenuPanel/GameNameTextInput.set_validation_label(data['status'])
	elif data["status"] == "success":
		_global_context.player_info["player_name"] = __player_name
		_global_context.player_info["game_name"] = __game_name
		_state_machine.set_state("res://client/lobby/LobbyState.tscn")
	
func on_BackButton_pressed():
	_state_machine.set_state("res://client/main_menu/MainMenuState.tscn")
