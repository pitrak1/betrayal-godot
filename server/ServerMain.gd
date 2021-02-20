extends Node

const __constants_script = preload("res://Constants.gd")
const __player_scene = preload("res://common/Player.tscn")
const __game_scene = preload("res://server/Game.tscn")


var __players = {}
var __games = {}
var __constants

func _ready():
	__constants = __constants_script.new()
	
func handle_incoming_network_command(command_type, sender_id, data):
	if sender_id in __players.keys() and __players[sender_id].get_game():
		return __players[sender_id].get_game().call(command_type, sender_id, data)
	else:
		return self.call(command_type, sender_id, data)
		
	
func __create_player(id, name, host):
	var player = __player_scene.instance()
	player.setup(name, host, null, null, id)
	__players[id] = player
	return player
	
func __create_game(name):
	var game = __game_scene.instance()
	game.name = name
	game.setup()
	__games[name] = game
	return game
	
func register_player_and_create_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in __players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif data["game_name"] in __games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		var player = __create_player(id, data["player_name"], true)
		var game = __create_game(data["game_name"])
		game.add_player(player)
	return result

func register_player_and_join_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in __players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif not data["game_name"] in __games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		var player = __create_player(id, data["player_name"], false)
		__games[data["game_name"]].add_player(player)
	return result
