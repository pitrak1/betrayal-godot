extends "res://client/State.gd"

const __turn_manager_script = preload("res://common/TurnManager.gd")
var __character_index
var __characters
var __unavailable_characters = []

func enter(custom_data):
	.enter(custom_data)
	
	$SelectButton.connect("pressed", self, "on_SelectButton_pressed")
	$LeftButton.connect("pressed", self, "on_LeftButton_pressed")
	$RightButton.connect("pressed", self, "on_RightButton_pressed")
	
	emit_signal("send_network_command", "get_current_player", {})
	
	__character_index = __turn_manager_script.new(_constants.characters.size())
	__characters = _constants.characters.duplicate(true)
	$TurnIndicator.setup(_custom_data["player_name"])
	self.__redraw()
	
func get_current_player_response(response):
	$TurnIndicator.set_player(response["current_player"])
	$SelectButton.visible = response["current_player"] == _custom_data["player_name"]
	__redraw()
	
func on_SelectButton_pressed():
	emit_signal(
		"send_network_command", 
		"select_character", 
		{ "character_index": __character_index.get_index() }
	)
	
func select_character_response(response):
	if response["all_selected"]:
		emit_signal(
			"change_state", 
			"CharacterConfirmationState", 
			_custom_data
		)
	else:
		for index in response["unavailable_characters"]:
			__characters[index]["status"] = "UNAVAILABLE"
		emit_signal("send_network_command", "get_current_player", {})
	
func on_LeftButton_pressed():
	__character_index.previous()
	__redraw()
	
func on_RightButton_pressed():
	__character_index.next()
	__redraw()
		
func __redraw():
	var entry = __characters[__character_index.get_index()]
	$ActorInfo.set_character_from_entry(entry)
