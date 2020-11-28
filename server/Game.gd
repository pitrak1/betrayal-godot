extends Node

var players = []
var waiting = 0
var current_player_index = 0
var unavailable_characters = []

func _ready():
	pass 
	
func add_player(player):
	player.game = self
	self.players.append(player)
	
func confirm_sync(id, data):
	self.waiting += 1
	if self.waiting >= self.players.size():
		self.waiting = 0
		return { 
			"response_type": "broadcast", 
			"response": { "status": "success" }, 
			"players": players 
		}
	else:
		return {
			"response_type": "none"
		}

func get_players(id, data):
	var parsed_players = []
	for player in players:
		parsed_players.append({
			"name": player.name,
			"host": player.host,
			"character_entry": player.character_entry
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
		"players": players 
	}
	
func start_game(id, data):
	return { 
		"response_type": "broadcast", 
		"response": { "status": "success" }, 
		"players": players 
	}
		
func get_current_player(id, data):
	return { 
		"response_type": "return", 
		"response": { 
			"status": "success", 
			"current_player": players[current_player_index].name
		}
	}
	
func select_character(id, data):
	
	var entry = $Constants.characters[data["character_index"]]
	
	self.unavailable_characters.append(data["character_index"])
	for i in range($Constants.characters.size()):
		if $Constants.characters[i]["key"] in entry["related"]:
			self.unavailable_characters.append(i)
			
	for p in players:
		if id == p.id:
			p.character_entry = $Constants.characters[data["character_index"]]
	
	var all_selected = false
	self.current_player_index += 1
	if self.current_player_index >= self.players.size():
		self.current_player_index = 0
		all_selected = true

	return {
		"response_type": "broadcast",
		"response": {
			"status": "success",
			"unavailable_characters": unavailable_characters,
			"all_selected": all_selected
		},
		"players": players
	}

