extends Node

var players = {}
var games = {}

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8910, 6)
	get_tree().network_peer = peer
	
func register_player(id, player_name):
	var response
	if id in players.keys():
		response = "invalid_player_name"
	else:
		response = "success"
		players[id] = { "name": player_name }
	return response
	
func create_game(id, game_name):
	var response
	if game_name in games.keys():
		response = "invalid_game_name"
	else:
		response = "success"
		games[game_name] = { "players": [id] }
		players[id]["game_name"] = game_name
	return response
	
func get_players(id, game_name):
	var response
	if not game_name in games.keys():
		response = { "status": "nonexistent_game" }
	else:
		response = { "status": "success", "player_names": [] }
		var player_ids = games[game_name]["players"]
		for player_id in player_ids:
			response["player_names"].append(players[player_id]["name"])
	return response
		
