extends Node

const __constants_script = preload("res://Constants.gd")
var __players = []
var __waiting = 0
var __current_player_index = 0
var __unavailable_characters = []
var __constants

func _ready():
	__constants = __constants_script.new()
	
func setup():
	__constants = __constants_script.new()
	
func add_player(player):
	player.set_game(self)
	__players.append(player)
	
func confirm_sync(_id, _data):
	__waiting += 1
	if __waiting >= __players.size():
		__waiting= 0
		return { 
			"response_type": "broadcast", 
			"response": { "status": "success" }, 
			"players": __players 
		}
	else:
		return {
			"response_type": "none"
		}

func get_players(_id, data):
	var parsed_players = []
	for player in __players:
		parsed_players.append({
			"name": player.name,
			"host": player.get_host(),
			"character_entry": player.get_character_entry()
		})
		
	var response_type = "broadcast"
	if data.get("response_type"):
		response_type = data.get("response_type")
		
	return { 
		"response_type": response_type, 
		"response": { 
			"status": "success", 
			"players": parsed_players
		}, 
		"players": __players 
	}
	
func start_game(_id, _data):
	return { 
		"response_type": "broadcast", 
		"response": { "status": "success" }, 
		"players": __players 
	}
		
func get_current_player(_id, _data):
	return { 
		"response_type": "return", 
		"response": { 
			"status": "success", 
			"current_player": __players[__current_player_index].name
		}
	}
	
func select_character(id, data):
	var entry = __constants.characters[data["character_index"]]
	
	__unavailable_characters.append(data["character_index"])
	for i in range(__constants.characters.size()):
		if __constants.characters[i]["key"] in entry["related"]:
			__unavailable_characters.append(i)
			
	for p in __players:
		if id == p.get_id():
			p.set_character_entry(__constants.characters[data["character_index"]])
	
	var all_selected = false
	__current_player_index += 1
	if __current_player_index >= __players.size():
		__current_player_index = 0
		all_selected = true

	return {
		"response_type": "broadcast",
		"response": {
			"status": "success",
			"unavailable_characters": __unavailable_characters,
			"all_selected": all_selected
		},
		"players": __players
	}

