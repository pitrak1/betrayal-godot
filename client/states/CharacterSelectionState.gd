extends "res://common/State.gd"

var character_index = 0
var unavailable_characters = []

func enter(custom_data):
	emit_signal("log_string", "Entering CharacterSelectionState...")
	$SelectButton.connect("pressed", self, "on_SelectButton_pressed")
	$LeftButton.connect("pressed", self, "on_LeftButton_pressed")
	$RightButton.connect("pressed", self, "on_RightButton_pressed")
	emit_signal("send_network_command", "get_current_player", {})
	var entry = $Constants.characters[character_index]
	$CharacterInfoPanel/ActorInfo.set_character_from_entry(entry)
	$CharacterInfoPanel/ActorInfo.set_status_label("")
	
func get_current_player_response(response):
	if response["is_current_player"]:
		$SelectButton.visible = true
		$PlayerLabel.text = "You are selecting."
	else:
		$SelectButton.visible = false
		$PlayerLabel.text = response["current_player"] + " is selecting."
	
func on_SelectButton_pressed():
	emit_signal("send_network_command", "select_character", { "character_index": character_index })
	
func select_character_response(response):
	if response["all_selected"]:
		print("To the next state!")
	else:
		unavailable_characters = response["unavailable_characters"]
		emit_signal("send_network_command", "get_current_player", {})
	
func on_LeftButton_pressed():
	character_index -= 1
	if character_index < 0:
		character_index = $Constants.characters.size() - 1
	var entry = $Constants.characters[character_index]
	$CharacterInfoPanel/ActorInfo.set_character_from_entry(entry)
	if character_index in unavailable_characters:
		$CharacterInfoPanel/ActorInfo.set_status_label("UNAVAILABLE")
	else:
		$CharacterInfoPanel/ActorInfo.set_status_label("")
	
func on_RightButton_pressed():
	character_index += 1
	if character_index > $Constants.characters.size() - 1:
		character_index = 0
	var entry = $Constants.characters[character_index]
	$CharacterInfoPanel/ActorInfo.set_character_from_entry(entry)
	if character_index in unavailable_characters:
		$CharacterInfoPanel/ActorInfo.set_status_label("UNAVAILABLE")
	else:
		$CharacterInfoPanel/ActorInfo.set_status_label("")
