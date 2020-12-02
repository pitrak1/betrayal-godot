extends "res://addons/gut/test.gd"

const __main_menu_state_scene = preload("res://client/states/MainMenuState.tscn")
var scene

func before_each():
	scene = __main_menu_state_scene.instance()
	watch_signals(scene)
	scene.enter({})

func test_clicking_on_host_button_transitions_to_host_join_game_state_with_host():
	scene.on_HostButton_pressed()
	assert_signal_emitted(scene, "change_state")
	var params = get_signal_emission_parameters(scene, "change_state")
	assert_eq(params[0], "HostJoinGameState")
	assert_true(params[1]["host"])

func test_clicking_on_join_button_transitions_to_host_join_game_state_without_host():
	scene.on_JoinButton_pressed()
	assert_signal_emitted(scene, "change_state")
	var params = get_signal_emission_parameters(scene, "change_state")
	assert_eq(params[0], "HostJoinGameState")
	assert_false(params[1]["host"])
