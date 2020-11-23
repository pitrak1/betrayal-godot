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
	
func player_sync():
	self.waiting += 1
	if self.waiting >= self.players.size():
		self.waiting = 0
		return true
	else:
		return false
		
func get_current_player():
	return players[current_player_index]
	
func select_character_by_index(player, index):
	var entry = $Constants.characters[index]
	
	self.unavailable_characters.append(index)
	for i in range($Constants.characters.size()):
		if $Constants.characters[i]["key"] in entry["related"]:
			self.unavailable_characters.append(i)
			
	player.character_entry = $Constants.characters[index]
	
func next_turn():
	self.current_player_index += 1
	if self.current_player_index >= self.players.size():
		self.current_player_index = 0
		return true
	else:
		return false
