extends "res://addons/gut/test.gd"

const __character_selection_state_scene = preload("res://client/states/CharacterSelectionState.tscn")
const __constants_script = preload("res://Constants.gd")
var scene
var __constants

func before_all():
	__constants = __constants_script.new()

func before_each():
	scene = __character_selection_state_scene.instance()
	watch_signals(scene)
	scene.enter({ "host": true, "player_name": "player1", "game_name": "lobby1" })

func test_shows_select_button_if_current_player():
	scene.get_current_player_response({ "current_player": "player1" })
	assert_true(scene.get_node("SelectButton").visible)

func test_hides_select_button_if_not_current_player():
	scene.get_current_player_response({ "current_player": "player2" })
	assert_false(scene.get_node("SelectButton").visible)

func test_sends_command_on_select_button_pressed():
	scene.on_SelectButton_pressed()
	assert_signal_emitted(scene, "send_network_command")

func test_displays_next_character_on_right_button_pressed():
	scene.on_RightButton_pressed()
	assert_eq(scene.get_node("ActorInfo").get_display_name(), __constants.characters[1]["display_name"])

func test_displays_first_character_if_last_character_displayed_on_right_button_pressed():
	for i in range(__constants.characters.size()):
		scene.on_RightButton_pressed()
	assert_eq(scene.get_node("ActorInfo").get_display_name(), __constants.characters[0]["display_name"])

func test_displays_previous_character_on_left_button_pressed():
	scene.on_RightButton_pressed()
	scene.on_LeftButton_pressed()
	assert_eq(scene.get_node("ActorInfo").get_display_name(), __constants.characters[0]["display_name"])

func test_displays_last_character_if_first_character_displayed_on_left_button_pressed():
	scene.on_LeftButton_pressed()
	assert_eq(scene.get_node("ActorInfo").get_display_name(), __constants.characters[__constants.characters.size() - 1]["display_name"])

func test_sends_command_on_select_character_response_if_not_all_selected():
	scene.select_character_response({
		"all_selected": false,
		"unavailable_characters": []
	})
	assert_signal_emitted(scene, "send_network_command")

func test_marks_characters_as_unavailable_on_select_character_response_if_not_all_selected():
	scene.select_character_response({
		"all_selected": false,
		"unavailable_characters": [3, 4]
	})
	for i in range(3):
		scene.on_RightButton_pressed()
	assert_eq(scene.get_node("ActorInfo").get_status_label(), "UNAVAILABLE")
	scene.on_RightButton_pressed()
	assert_eq(scene.get_node("ActorInfo").get_status_label(), "UNAVAILABLE")	
	scene.on_RightButton_pressed()
	assert_eq(scene.get_node("ActorInfo").get_status_label(), "")	

func test_transitions_on_select_character_response_if_all_selected():
	scene.select_character_response({
		"all_selected": true,
		"unavailable_characters": []
	})
	assert_signal_emitted(scene, "change_state")
	assert_eq(get_signal_emission_parameters(scene, "change_state")[0], "CharacterConfirmationState")
