extends Node

signal log_string(string)

var players = {}
var games = {}

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8910, 6)
	get_tree().network_peer = peer
	
func register_player_and_create_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif data["game_name"] in games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		players[id] = { "name": data["player_name"], "game_name": data["game_name"], "host": true, "character_index": null }
		games[data["game_name"]] = { "players": [id], "waiting": 0, "current_player_index": 0, "unavailable_characters": [] }
	return result

func register_player_and_join_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif not data["game_name"] in games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		players[id] = { "name": data["player_name"], "game_name": data["game_name"], "host": false, "character_index": null }
		games[data["game_name"]]["players"].append(id)
	return result
	
func get_players(id, data):
	var player_ids = games[players[id]["game_name"]]["players"]
	var result = { "response_type": "broadcast", "response": { "status": "success", "players": [] }, "player_ids": player_ids }
	for player_id in player_ids:
		result["response"]["players"].append(players[player_id])
	return result
	
func start_game(id, data):
	var player_ids = games[players[id]["game_name"]]["players"]
	return { "response_type": "broadcast", "response": { "status": "success" }, "player_ids": player_ids }
	
func get_player_order(id, data):
	var player_ids = games[players[id]["game_name"]]["players"]
	var player_names = []
	for player_id in player_ids:
		player_names.append(players[player_id]["name"])
	return { "response_type": "return", "response": { "status": "success", "player_names": player_names } }
		
func confirm_player_order(id, data):
	var game = games[players[id]["game_name"]]
	var player_ids = game["players"]
	game["waiting"] += 1
	if game["waiting"] >= player_ids.size():
		game["waiting"] = 0
		return { "response_type": "broadcast", "response": { "status": "success", "ready": true }, "player_ids": player_ids }

func get_current_player(id, data):
	var game = games[players[id]["game_name"]]
	return { 
		"response_type": "return", 
		"response": { 
			"status": "success", 
			"current_player": players[game["players"][game["current_player_index"]]]["name"], 
			"is_current_player": game["players"][game["current_player_index"]] == id
		}
	}
	
func select_character(id, data):
	var game = games[players[id]["game_name"]]
	game["unavailable_characters"].append(data["character_index"])
	var entry = $Constants.characters[data["character_index"]]
	for i in range($Constants.characters.size()):
		if $Constants.characters[i]["key"] in entry["related"]:
			game["unavailable_characters"].append(i)
	players[id]["character_index"] = data["character_index"]
	game["current_player_index"] += 1
	
	var all_selected = false
	if game["current_player_index"] >= game["players"].size():
		all_selected = true
		game["current_player_index"] = 0
		
	return {
		"response_type": "broadcast",
		"response": {
			"status": "success",
			"unavailable_characters": game["unavailable_characters"],
			"all_selected": all_selected
		},
		"player_ids": game["players"]
	}
	
func get_character_selections(id, data):
	var player_ids = games[players[id]["game_name"]]["players"]
	var player_selections = []
	for player_id in player_ids:
		var player_name = players[player_id]["name"]
		var character_name = $Constants.characters[players[player_id]["character_index"]]["display_name"] 
		player_selections.append({ 
			"player_name": player_name, 
			"character_name": character_name
		})
	return { "response_type": "return", "response": { "status": "success", "selections": player_selections } }
	
func confirm_character_selections(id, data):
	var game = games[players[id]["game_name"]]
	var player_ids = game["players"]
	game["waiting"] += 1
	if game["waiting"] >= player_ids.size():
		game["waiting"] = 0
		return { "response_type": "broadcast", "response": { "status": "success", "ready": true }, "player_ids": player_ids }
