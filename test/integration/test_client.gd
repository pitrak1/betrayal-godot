extends "res://addons/gut/test.gd"

class TestSplashState:
	extends "res://addons/gut/test.gd"
	
	var client_scene = preload("res://client/ClientMain.tscn")
	var splash_state = preload("res://client/states/SplashState.gd")
	var main_menu_state = preload("res://client/states/MainMenuState.gd")
	var player
	
	func before_each():
		player = partial_double(client_scene).instance()
		add_child(player)
		
	func after_each():
		remove_child(player)
	
	func test_starts_in_splash_state():
		assert_true(player.current_state is splash_state)
		
	func test_clicking_start_button_transitions_to_main_menu_state():
		player.current_state.on_StartButton_pressed()
		assert_true(player.current_state is main_menu_state)
		
class TestMainMenuState:
	extends "res://addons/gut/test.gd"
	
	var client_scene = preload("res://client/ClientMain.tscn")
	var main_menu_state = preload("res://client/states/MainMenuState.gd")
	var host_join_game_state = preload("res://client/states/HostJoinGameState.gd")
	var player
	
	func before_each():
		player = partial_double(client_scene).instance()
		add_child(player)
		player.current_state.on_StartButton_pressed()
		
	func after_each():
		remove_child(player)
		
	func test_clicking_on_host_button_transitions_to_host_join_game_state_with_host():
		player.current_state.on_HostButton_pressed()
		assert_true(player.current_state is host_join_game_state)
		assert_true(player.current_state.custom_data["host"])
		
	func test_clicking_on_join_button_transitions_to_host_join_game_state_without_host():
		player.current_state.on_JoinButton_pressed()
		assert_true(player.current_state is host_join_game_state)
		assert_false(player.current_state.custom_data["host"])
		
class TestHostJoinGameState:
	extends "res://addons/gut/test.gd"
	
	var client_scene = preload("res://client/ClientMain.tscn")
	var host_join_game_state = preload("res://client/states/HostJoinGameState.gd")
	var lobby_state = preload("res://client/states/LobbyState.gd")
	var player
	
	func before_each():
		player = partial_double(client_scene).instance()
		stub(player, 'on_send_network_command').to_do_nothing()
		add_child(player)
		player.current_state.on_StartButton_pressed()
		player.current_state.on_HostButton_pressed()
		watch_signals(player.current_state)
		player.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("12345")
		player.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("12345")
		
	func after_each():
		remove_child(player)
		
	func test_player_name_must_be_more_than_4_characters():
		player.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("1234")
		player.current_state.on_StartButton_pressed()
		assert_signal_not_emitted(player.current_state, "send_network_command")
		
	func test_player_name_must_be_less_than_16_characters():
		player.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("1234567890123456")
		player.current_state.on_StartButton_pressed()
		assert_signal_not_emitted(player.current_state, "send_network_command")
		
	func test_player_name_must_not_have_non_alphanumeric_characters():
		player.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("123 45")
		player.current_state.on_StartButton_pressed()
		assert_signal_not_emitted(player.current_state, "send_network_command")
		
	func test_game_name_must_be_more_than_4_characters():
		player.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("1234")
		player.current_state.on_StartButton_pressed()
		assert_signal_not_emitted(player.current_state, "send_network_command")
		
	func test_game_name_must_be_less_than_16_characters():
		player.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("1234567890123456")
		player.current_state.on_StartButton_pressed()
		assert_signal_not_emitted(player.current_state, "send_network_command")
		
	func test_game_name_must_not_have_non_alphanumeric_characters():
		player.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("123`45")
		player.current_state.on_StartButton_pressed()
		assert_signal_not_emitted(player.current_state, "send_network_command")
		
	func test_sends_command_if_player_and_game_names_are_valid():
		player.current_state.on_StartButton_pressed()
		assert_signal_emitted(player.current_state, "send_network_command")
		
	func test_does_not_transition_if_player_name_invalid():
		player.current_state.register_player_and_create_game_response({ "status": "invalid_player_name" })
		assert_true(player.current_state is host_join_game_state)
		
	func test_does_not_transition_if_game_name_invalid():
		player.current_state.register_player_and_create_game_response({ "status": "invalid_game_name" })
		assert_true(player.current_state is host_join_game_state)
		
	func test_transitions_if_success():
		player.current_state.on_StartButton_pressed()
		player.current_state.register_player_and_create_game_response({ "status": "success" })
		assert_true(player.current_state is lobby_state)
	

	


