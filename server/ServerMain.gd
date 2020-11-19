extends Node

signal log_string(string)

var players = {}
var games = {}

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8910, 6)
	get_tree().network_peer = peer
	
func register_player_and_create_game(id, player_name, game_name):
	var response
	if id in players.keys():
		response = "invalid_player_name"
	elif game_name in games.keys():
		response = "invalid_game_name"
	else:
		response = "success"
		players[id] = { "name": player_name, "game_name": game_name, "host": true }
		games[game_name] = { "players": [id] }
	return response

func register_player_and_join_game(id, player_name, game_name):
	var response
	if id in players.keys():
		response = "invalid_player_name"
	elif not game_name in games.keys():
		response = "invalid_game_name"
	else:
		response = "success"
		players[id] = { "name": player_name, "game_name": game_name, "host": false }
		games[game_name]["players"].append(id)
	return response
	
func get_players(id, game_name):
	var response
	if not game_name in games.keys():
		response = { "status": "nonexistent_game" }
	else:
		var player_ids = games[game_name]["players"]
		response = { "status": "success", "players": [], "player_ids": player_ids }
		for player_id in player_ids:
			response["players"].append(players[player_id])
	return response
	
func start_game(id):
	var player_ids = games[players[id]["game_name"]]["players"]
	return { "status": "success", "player_ids": player_ids }
	
func get_player_order(id):
	var player_ids = games[players[id]["game_name"]]["players"]
	var player_names = []
	for player_id in player_ids:
		player_names.append(players[player_id]["name"])
	return { "status": "success", "player_ids": player_ids, "player_names": player_names }
		
