extends "res://client/State.gd"

const __setup_game_script = preload("res://common/SetupGame.gd")
onready var __setup_game = __setup_game_script.new()
var __players

func _ready():
	$UICanvasLayer/ContinueButton.connect("pressed", self, "on_ContinueButton_pressed")
	send_network_command("get_players", { "response_type": "return" })

func get_players_response(response):
	__players = response["players"]
	for player in response["players"]:
		$UICanvasLayer/CharacterSelectionLabel.text += player["name"] + ": " \
			+ player["character_entry"]["display_name"] + "\n"
		
func on_ContinueButton_pressed():
	$UICanvasLayer/WaitingLabel.visible = true
	send_network_command("confirm_sync", {})
	
func confirm_sync_response(_response):
	var setup = __setup_game_script.new()
	setup.setup(_global_context, __players)
	
	_state_machine.set_state("res://client/game_turn/GameTurnState.tscn")
