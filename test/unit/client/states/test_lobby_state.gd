extends "res://addons/gut/test.gd"

const __lobby_state_scene = preload("res://client/states/LobbyState.tscn")
var scene

func before_each():
	scene = __lobby_state_scene.instance()
	watch_signals(scene)

func test_start_button_is_invisible_if_not_host():
	scene.enter({ "host": false,  "game_name": "lobby1", "player_name": "player1" })
	assert_false(scene.get_node("MenuPanel/StartButton").visible)

func test_start_button_is_visible_if_host():
	scene.enter({ "host": true,  "game_name": "lobby1", "player_name": "player1" })
	assert_true(scene.get_node("MenuPanel/StartButton").visible)

func test_back_button_transitions_to_main_menu_state():
	scene.enter({ "host": true,  "game_name": "lobby1", "player_name": "player1" })
	scene.on_BackButton_pressed(true)
	assert_signal_emitted(scene, "change_state")
	assert_eq(get_signal_emission_parameters(scene, "change_state")[0], "MainMenuState")

func test_displays_players_when_received():
	scene.enter({ "host": true,  "game_name": "lobby1", "player_name": "player1" })
	scene.get_players_response({
		"status": "success",
		"players": [
			{ "name": "player1", "host": true },
			{ "name": "player2", "host": false }
		]
	})
	assert_eq(scene.get_node("MenuPanel/LobbyPlayer1").get_player_name(), "player1")
	assert_true(scene.get_node("MenuPanel/LobbyPlayer1").get_host_indicator())
	assert_eq(scene.get_node("MenuPanel/LobbyPlayer2").get_player_name(), "player2")
	assert_false(scene.get_node("MenuPanel/LobbyPlayer2").get_host_indicator())
	assert_eq(scene.get_node("MenuPanel/LobbyPlayer3").get_player_name(), "")
	assert_false(scene.get_node("MenuPanel/LobbyPlayer3").get_host_indicator())

func test_start_button_sends_start_game_command():
	scene.enter({ "host": true,  "game_name": "lobby1", "player_name": "player1" })
	scene.on_StartButton_pressed()
	assert_signal_emitted(scene, "send_network_command")
	assert_eq(get_signal_emission_parameters(scene, "send_network_command")[0], "start_game")

func test_transitions_to_player_order_state_on_start_game_response():
	scene.enter({ "host": true,  "game_name": "lobby1", "player_name": "player1" })
	scene.start_game_response({})
	assert_signal_emitted(scene, "change_state")
	assert_eq(get_signal_emission_parameters(scene, "change_state")[0], "PlayerOrderState")

