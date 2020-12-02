extends "res://addons/gut/test.gd"

const __splash_state_scene = preload("res://client/states/SplashState.tscn")
var scene

func before_each():
	scene = __splash_state_scene.instance()
	watch_signals(scene)
	scene.enter({})

func test_clicking_start_button_transitions_to_main_menu_state():
	scene.on_StartButton_pressed()
	assert_signal_emitted(scene, "change_state")
	assert_eq(get_signal_emission_parameters(scene, "change_state")[0], "MainMenuState")
