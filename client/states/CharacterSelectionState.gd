extends "res://client/State.gd"

const __turn_manager_script = preload("res://common/TurnManager.gd")
var __character_index
var __characters
var __unavailable_characters = []

func _ready():
	$UICanvasLayer/SelectButton.connect("pressed", self, "on_SelectButton_pressed")
	$UICanvasLayer/LeftButton.connect("pressed", self, "on_LeftButton_pressed")
	$UICanvasLayer/RightButton.connect("pressed", self, "on_RightButton_pressed")
	
	send_network_command("get_current_player", {})
	
	__character_index = __turn_manager_script.new(_constants.characters.size())
	__characters = _constants.characters.duplicate(true)
	$UICanvasLayer/TurnIndicator.setup(_global_context.player_info["player_name"])
	self.__redraw()
	
func get_current_player_response(response):
	$UICanvasLayer/TurnIndicator.set_player(response["current_player"])
	$UICanvasLayer/SelectButton.visible = response["current_player"] == _global_context.player_info["player_name"]
	__redraw()
	
func on_SelectButton_pressed():
	send_network_command("select_character", { "character_index": __character_index.get_index() })
	
func select_character_response(response):
	if response["all_selected"]:
		_state_machine.goto_scene("res://client/states/CharacterConfirmationState.tscn")
	else:
		for index in response["unavailable_characters"]:
			__characters[index]["status"] = "UNAVAILABLE"
		send_network_command("get_current_player", {})
	
func on_LeftButton_pressed():
	__character_index.previous()
	__redraw()
	
func on_RightButton_pressed():
	__character_index.next()
	__redraw()
		
func __redraw():
	var entry = __characters[__character_index.get_index()]
	$UICanvasLayer/CharacterInfoPanel/ActorInfo.set_character_from_entry(entry)
