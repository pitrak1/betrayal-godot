extends Node

var client_scene = preload("res://client/ClientMain.tscn")
var server_scene = preload("res://server/ServerMain.tscn")

func _ready():
	print("Application started")
	if OS.has_feature("server"):
		print("Is server")
		add_child(server_scene.instance())
	elif OS.has_feature("client"):
		print("Is client")
		add_child(client_scene.instance())
	else:
		print("Could not detect application type! Defaulting to client.")
		add_child(client_scene.instance())
#		add_child(server_scene.instance())
		
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func __is_server():
	return get_tree().get_network_unique_id() == 1

func _player_connected(id):
	print("player_connected: " + str(id))

func _player_disconnected(id):
	print("player_disconnected: " + str(id))

func _connected_ok():
	print("connected_ok")

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func server_register_player(data):
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.register_player(sender_id, data["player_name"])
	rpc_id(sender_id, "client_register_player_response", response)
	
func client_register_player(data):
	rpc_id(1, "server_register_player", data)
	
remote func client_register_player_response(status):
	$ClientMain.on_receive_network_response("register_player", status)
	
remote func server_create_game(data):
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.create_game(sender_id, data["game_name"])
	rpc_id(sender_id, "client_create_game_response", response)
	
func client_create_game(data):
	rpc_id(1, "server_create_game", data)
	
remote func client_create_game_response(status):
	$ClientMain.on_receive_network_response("create_game", status)
	
remote func server_get_players(data):
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.get_players(sender_id, data["game_name"])
	rpc_id(sender_id, "client_get_players_response", response)
	
func client_get_players(data):
	rpc_id(1, "server_get_players", data)
	
remote func client_get_players_response(data):
	$ClientMain.on_receive_network_response("get_players", data)
