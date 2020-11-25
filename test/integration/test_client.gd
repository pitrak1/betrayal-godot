extends "res://addons/gut/test.gd"
	
var client_scene = preload("res://client/ClientMain.tscn")
var splash_state = preload("res://client/states/SplashState.gd")
var main_menu_state = preload("res://client/states/MainMenuState.gd")
var client

func before_each():
	client = client_scene.instance()
	add_child(client)
	
func after_each():
	remove_child(client)

func test_starts_in_splash_state():
	assert_true(client.current_state is splash_state)
	
func test_clicking_start_button_transitions_to_main_menu_state():
	client.current_state.on_StartButton_pressed()
	assert_true(client.current_state is main_menu_state)


