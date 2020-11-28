extends Node

signal log_string(string)

var player_scene = preload("res://common/Player.tscn")
var game_scene = preload("res://server/Game.tscn")

var players = {}
var games = {}

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8910, 6)
	get_tree().network_peer = peer
	
func handle_incoming_network_command(command_type, sender_id, data):
	if sender_id in players.keys() and players[sender_id].game:
		return players[sender_id].game.call(command_type, sender_id, data)
	else:
		return self.call(command_type, sender_id, data)
		
	
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
