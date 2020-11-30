extends "res://addons/gut/test.gd"

const __player_order_state_scene = preload("res://client/states/PlayerOrderState.tscn")
var scene

func before_each():
	scene = __player_order_state_scene.instance()
	watch_signals(scene)
	scene.enter({})

func test_shows_players_on_get_players_response():
	scene.get_players_response({ 
		"players": [
			{ "name": "player1" },
			{ "name": "player2" }
		]
	})
	assert_eq(scene.get_node("PlayerOrderLabel").text, "player1, player2")

func test_sends_confirm_sync_command_when_continue_button_pressed():
	scene.on_ContinueButton_pressed()
	assert_signal_emitted(scene, "send_network_command")
	assert_eq(get_signal_emission_parameters(scene, "send_network_command")[0], "confirm_sync")

func test_transitions_to_character_selection_state_on_confirm_sync_response():
	scene.confirm_sync_response({})
	assert_signal_emitted(scene, "change_state")
	assert_eq(get_signal_emission_parameters(scene, "change_state")[0], "CharacterSelectionState")

