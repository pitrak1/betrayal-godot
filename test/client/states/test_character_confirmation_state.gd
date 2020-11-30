extends "res://addons/gut/test.gd"

const __character_confirmation_state_scene = preload("res://client/states/CharacterConfirmationState.tscn")
const __constants_script = preload("res://Constants.gd")
var scene
var __constants

func before_all():
	__constants = __constants_script.new()

func before_each():
	scene = __character_confirmation_state_scene.instance()
	watch_signals(scene)
	scene.enter({ "host": true, "player_name": "player1", "game_name": "lobby1" })

func test_displays_character_selections_on_get_players_response():
	scene.get_players_response({
		"players": [
			{
				"name": "player1",
				"host": true,
				"character_entry": __constants.characters[0]
			},
			{
				"name": "player2",
				"host": false,
				"character_entry": __constants.characters[2]
			},
		]
	})
	assert_eq(scene.get_node("CharacterSelectionLabel").text, "player1: Heather Granville\nplayer2: Madame Zostra\n")

func test_sends_command_on_continue_button_pressed():
	scene.on_ContinueButton_pressed()
	assert_signal_emitted(scene, "send_network_command")
	assert_eq(get_signal_emission_parameters(scene, "send_network_command")[0], "confirm_sync")

func test_transitions_on_confirm_sync_response():
	scene.get_players_response({
		"players": [
			{
				"name": "player1",
				"host": true,
				"character_entry": __constants.characters[0]
			},
			{
				"name": "player2",
				"host": false,
				"character_entry": __constants.characters[2]
			},
		]
	})
	scene.confirm_sync_response({})
	assert_signal_emitted(scene, "change_state")
	assert_eq(get_signal_emission_parameters(scene, "change_state")[0], "TurnGameState")
