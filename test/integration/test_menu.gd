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
		
class TestLobbyState:
	extends "res://addons/gut/test.gd"
	
	var client_scene = preload("res://client/ClientMain.tscn")
	var lobby_state = preload("res://client/states/LobbyState.gd")
	var main_menu_state = preload("res://client/states/MainMenuState.gd")
	var player_order_state = preload("res://client/states/PlayerOrderState.gd")
	var host
	var client
	
	func before_each():
		host = partial_double(client_scene).instance()
		stub(host, 'on_send_network_command').to_do_nothing()
		add_child(host)
		host.current_state.on_StartButton_pressed()
		host.current_state.on_HostButton_pressed()
		host.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("player1")
		host.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("lobby1")
		host.current_state.on_StartButton_pressed()
		host.current_state.register_player_and_create_game_response({ "status": "success" })
		watch_signals(host.current_state)
		
		client = partial_double(client_scene).instance()
		stub(client, 'on_send_network_command').to_do_nothing()
		add_child(client)
		client.current_state.on_StartButton_pressed()
		client.current_state.on_JoinButton_pressed()
		client.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("player2")
		client.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("lobby1")
		client.current_state.on_StartButton_pressed()
		client.current_state.register_player_and_create_game_response({ "status": "success" })
		watch_signals(client.current_state)
		
	func after_each():
		remove_child(host)
		remove_child(client)
		
	func test_start_button_is_invisible_if_not_host():
		assert_false(client.current_state.get_node("MenuPanel/StartButton").visible)
		
	func test_start_button_is_visible_if_host():
		assert_true(host.current_state.get_node("MenuPanel/StartButton").visible)
		
	func test_back_button_transitions_to_main_menu_state():
		client.current_state.on_BackButton_pressed()
		assert_true(client.current_state is main_menu_state)
		
	func test_displays_players_when_received():
		client.current_state.get_players_response({
			"status": "success",
			"players": [
				{ "name": "player1", "host": true },
				{ "name": "player2", "host": false }
			]
		})
		assert_eq(client.current_state.get_node("MenuPanel/LobbyPlayer1").get_player_name(), "player1")
		assert_true(client.current_state.get_node("MenuPanel/LobbyPlayer1").get_host_indicator())
		assert_eq(client.current_state.get_node("MenuPanel/LobbyPlayer2").get_player_name(), "player2")
		assert_false(client.current_state.get_node("MenuPanel/LobbyPlayer2").get_host_indicator())
		assert_eq(client.current_state.get_node("MenuPanel/LobbyPlayer3").get_player_name(), "")
		assert_false(client.current_state.get_node("MenuPanel/LobbyPlayer3").get_host_indicator())
	
	func test_start_button_sends_signal():
		client.current_state.on_StartButton_pressed()
		assert_signal_emitted(client.current_state, "send_network_command")
		
	func test_transitions_on_start_game_response():
		client.current_state.start_game_response({})
		assert_true(client.current_state is player_order_state)

class TestPlayerOrderState:
	extends "res://addons/gut/test.gd"
	
	var client_scene = preload("res://client/ClientMain.tscn")
	var player_order_state = preload("res://client/states/PlayerOrderState.gd")
	var character_selection_state = preload("res://client/states/CharacterSelectionState.gd")
	var player
	
	func before_each():
		player = partial_double(client_scene).instance()
		stub(player, 'on_send_network_command').to_do_nothing()
		add_child(player)
		player.current_state.on_StartButton_pressed()
		player.current_state.on_HostButton_pressed()
		player.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("player1")
		player.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("lobby1")
		player.current_state.on_StartButton_pressed()
		player.current_state.register_player_and_create_game_response({ "status": "success" })
		player.current_state.start_game_response({})
		watch_signals(player.current_state)
		
	func test_shows_players_on_get_players_response():
		player.current_state.get_players_response({ 
			"players": [
				{ "name": "player1" },
				{ "name": "player2" }
			]
		})
		assert_eq(player.current_state.get_node("PlayerOrderLabel").text, "player1, player2")
		
	func test_sends_command_when_continue_button_pressed():
		player.current_state.on_ContinueButton_pressed()
		assert_signal_emitted(player.current_state, "send_network_command")

	func test_transitions_on_confirm_sync_response():
		player.current_state.confirm_sync_response({})
		assert_true(player.current_state is character_selection_state)
		
class TestCharacterSelectionState:
	extends "res://addons/gut/test.gd"
	
	var client_scene = preload("res://client/ClientMain.tscn")
	var character_selection_state = preload("res://client/states/CharacterSelectionState.gd")
	var character_confirmation_state = preload("res://client/states/CharacterConfirmationState.gd")
	var constants = preload("res://common/Constants.tscn")
	var player
	
	func before_each():
		player = partial_double(client_scene).instance()
		stub(player, 'on_send_network_command').to_do_nothing()
		add_child(player)
		player.current_state.on_StartButton_pressed()
		player.current_state.on_HostButton_pressed()
		player.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("player1")
		player.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("lobby1")
		player.current_state.on_StartButton_pressed()
		player.current_state.register_player_and_create_game_response({ "status": "success" })
		player.current_state.start_game_response({})
		player.current_state.confirm_sync_response({})
		watch_signals(player.current_state)
		
		var constants_node = constants.instance()
		add_child(constants_node)
	
	func test_shows_select_button_if_current_player():
		player.current_state.get_current_player_response({ "current_player": "player1" })
		assert_true(player.current_state.get_node("SelectButton").visible)

	func test_hides_select_button_if_not_current_player():
		player.current_state.get_current_player_response({ "current_player": "player2" })
		assert_false(player.current_state.get_node("SelectButton").visible)

	func test_sends_command_on_select_button_pressed():
		player.current_state.on_SelectButton_pressed()
		assert_signal_emitted(player.current_state, "send_network_command")
		
	func test_displays_next_character_on_right_button_pressed():
		player.current_state.on_RightButton_pressed()
		assert_eq(player.current_state.get_node("CharacterInfoPanel/ActorInfo").get_display_name(), $Constants.characters[1]["display_name"])
		
	func test_displays_first_character_if_last_character_displayed_on_right_button_pressed():
		for i in range($Constants.characters.size()):
			player.current_state.on_RightButton_pressed()
		assert_eq(player.current_state.get_node("CharacterInfoPanel/ActorInfo").get_display_name(), $Constants.characters[0]["display_name"])
		
	func test_displays_previous_character_on_left_button_pressed():
		player.current_state.on_RightButton_pressed()
		player.current_state.on_LeftButton_pressed()
		assert_eq(player.current_state.get_node("CharacterInfoPanel/ActorInfo").get_display_name(), $Constants.characters[0]["display_name"])
		
	func test_displays_last_character_if_first_character_displayed_on_left_button_pressed():
		player.current_state.on_LeftButton_pressed()
		assert_eq(player.current_state.get_node("CharacterInfoPanel/ActorInfo").get_display_name(), $Constants.characters[$Constants.characters.size() - 1]["display_name"])
		
	func test_sends_command_on_select_character_response_if_not_all_selected():
		player.current_state.select_character_response({
			"all_selected": false,
			"unavailable_characters": []
		})
		assert_signal_emitted(player.current_state, "send_network_command")
		
	func test_marks_characters_as_unavailable_on_select_character_response_if_not_all_selected():
		player.current_state.select_character_response({
			"all_selected": false,
			"unavailable_characters": [3, 4]
		})
		for i in range(3):
			player.current_state.on_RightButton_pressed()
		assert_eq(player.current_state.get_node("CharacterInfoPanel/ActorInfo").get_status_label(), "UNAVAILABLE")
		player.current_state.on_RightButton_pressed()
		assert_eq(player.current_state.get_node("CharacterInfoPanel/ActorInfo").get_status_label(), "UNAVAILABLE")	
		player.current_state.on_RightButton_pressed()
		assert_eq(player.current_state.get_node("CharacterInfoPanel/ActorInfo").get_status_label(), "")	

	func test_transitions_on_select_character_response_if_all_selected():
		player.current_state.select_character_response({
			"all_selected": true,
			"unavailable_characters": []
		})
		assert_true(player.current_state is character_confirmation_state)
		
class TestCharacterConfirmationState:
	extends "res://addons/gut/test.gd"
	
	var client_scene = preload("res://client/ClientMain.tscn")
	var character_confirmation_state = preload("res://client/states/CharacterConfirmationState.gd")
	var turn_game_state = preload("res://client/states/TurnGameState.gd")
	var constants = preload("res://common/Constants.tscn")
	var player
	
	func before_each():
		player = partial_double(client_scene).instance()
		stub(player, 'on_send_network_command').to_do_nothing()
		add_child(player)
		player.current_state.on_StartButton_pressed()
		player.current_state.on_HostButton_pressed()
		player.current_state.get_node("MenuPanel/PlayerNameTextInput").set_input_text("player1")
		player.current_state.get_node("MenuPanel/GameNameTextInput").set_input_text("lobby1")
		player.current_state.on_StartButton_pressed()
		player.current_state.register_player_and_create_game_response({ "status": "success" })
		player.current_state.start_game_response({})
		player.current_state.confirm_sync_response({})
		player.current_state.select_character_response({ "all_selected": true })
		watch_signals(player.current_state)
		
		var constants_node = constants.instance()
		add_child(constants_node)
		
	func test_displays_character_selections_on_get_players_response():
		player.current_state.get_players_response({
			"players": [
				{
					"name": "player1",
					"host": true,
					"character_entry": $Constants.characters[0]
				},
				{
					"name": "player2",
					"host": false,
					"character_entry": $Constants.characters[2]
				},
			]
		})
		assert_eq(player.current_state.get_node("CharacterSelectionLabel").text, "player1: Heather Granville\nplayer2: Madame Zostra\n")

	func test_sends_command_on_continue_button_pressed():
		player.current_state.on_ContinueButton_pressed()
		assert_signal_emitted(player.current_state, "send_network_command")
		
	func test_transitions_on_confirm_sync_response():
		player.current_state.get_players_response({
			"players": [
				{
					"name": "player1",
					"host": true,
					"character_entry": $Constants.characters[0]
				},
				{
					"name": "player2",
					"host": false,
					"character_entry": $Constants.characters[2]
				},
			]
		})
		player.current_state.confirm_sync_response({})
		assert_true(player.current_state is turn_game_state)
