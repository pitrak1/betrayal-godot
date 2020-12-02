extends "res://addons/gut/test.gd"

const __host_join_game_state_scene = preload("res://client/states/HostJoinGameState.tscn")
var scene

func before_each():
	scene = __host_join_game_state_scene.instance()
	watch_signals(scene)
	scene.enter({}, true)
	scene.get_node("PlayerNameTextInput").set_input_text("12345")
	scene.get_node("GameNameTextInput").set_input_text("12345")
	
func test_player_name_must_be_more_than_4_characters():
	scene.get_node("PlayerNameTextInput").set_input_text("1234")
	scene.on_StartButton_pressed()
	assert_signal_not_emitted(scene, "send_network_command")

func test_player_name_must_be_less_than_16_characters():
	scene.get_node("PlayerNameTextInput").set_input_text("1234567890123456")
	scene.on_StartButton_pressed()
	assert_signal_not_emitted(scene, "send_network_command")
 
func test_player_name_must_not_have_non_alphanumeric_characters():
	scene.get_node("PlayerNameTextInput").set_input_text("123 45")
	scene.on_StartButton_pressed()
	assert_signal_not_emitted(scene, "send_network_command")
 
func test_game_name_must_be_more_than_4_characters():
	scene.get_node("GameNameTextInput").set_input_text("1234")
	scene.on_StartButton_pressed()
	assert_signal_not_emitted(scene, "send_network_command")
 
func test_game_name_must_be_less_than_16_characters():
	scene.get_node("GameNameTextInput").set_input_text("1234567890123456")
	scene.on_StartButton_pressed()
	assert_signal_not_emitted(scene, "send_network_command")
 
func test_game_name_must_not_have_non_alphanumeric_characters():
	scene.get_node("GameNameTextInput").set_input_text("123`45")
	scene.on_StartButton_pressed()
	assert_signal_not_emitted(scene, "send_network_command")
 
func test_sends_command_if_player_and_game_names_are_valid():
	scene.on_StartButton_pressed()
	assert_signal_emitted(scene, "send_network_command")
 
func test_does_not_transition_if_player_name_invalid():
	scene.register_player_and_create_game_response({ "status": "invalid_player_name" })
	assert_signal_not_emitted(scene, "change_state")
 
func test_does_not_transition_if_game_name_invalid():
	scene.register_player_and_create_game_response({ "status": "invalid_game_name" })
	assert_signal_not_emitted(scene, "change_state")
 
func test_transitions_if_success():
	scene.on_StartButton_pressed()
	scene.register_player_and_create_game_response({ "status": "success" })
	assert_signal_emitted(scene, "change_state")
	assert_eq(get_signal_emission_parameters(scene, "change_state")[0], "LobbyState")

 
