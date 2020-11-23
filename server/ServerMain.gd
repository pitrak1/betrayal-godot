extends Node

signal log_string(string)

var player_scene = preload("res://common/Player.tscn")
var game_scene = preload("res://common/Game.tscn")

var players = {}
var games = {}

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8910, 6)
	get_tree().network_peer = peer
	
func __create_player(id, name, host):
	var player = player_scene.instance()
	player.name = name
	player.id = id
	player.host = host
	players[id] = player
	return player
	
func __create_game(name):
	var game = game_scene.instance()
	game.name = name
	games[name] = game
	return game
	
func register_player_and_create_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif data["game_name"] in games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		var player = __create_player(id, data["player_name"], true)
		var game = __create_game(data["game_name"])
		game.add_player(player)
	return result

func register_player_and_join_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif not data["game_name"] in games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		var player = __create_player(id, data["player_name"], false)
		games[data["game_name"]].add_player(player)
	return result
	
func get_players(id, data):
	var parsed_players = []
	for player in players[id].game.players:
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
		"players": players[id].game.players 
	}

func start_game(id, data):
	return { 
		"response_type": "broadcast", 
		"response": { "status": "success" }, 
		"players": players[id].game.players 
	}
		
func confirm_sync(id, data):
	var game = players[id].game
	if game.player_sync():
		return { 
			"response_type": "broadcast", 
			"response": { "status": "success" }, 
			"players": game.players 
		}
	else:
		return {
			"response_type": "none"
		}

func get_current_player(id, data):
	return { 
		"response_type": "return", 
		"response": { 
			"status": "success", 
			"current_player": players[id].game.get_current_player().name
		}
	}
	
func select_character(id, data):
	var game = players[id].game
	game.select_character_by_index(players[id], data["character_index"])

	return {
		"response_type": "broadcast",
		"response": {
			"status": "success",
			"unavailable_characters": game.unavailable_characters,
			"all_selected": game.next_turn()
		},
		"players": game.players
	}
