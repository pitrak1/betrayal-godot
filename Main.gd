extends Node

signal log_string(string)

var client_scene = preload("res://client/ClientMain.tscn")
var server_scene = preload("res://server/ServerMain.tscn")

func _ready():
	connect("log_string", self, "on_log_string")
	emit_signal("log_string", "Application started!")
	
	if OS.has_feature("server"):
		emit_signal("log_string", "Starting server...")
		var scene = server_scene.instance()
		scene.connect("log_string", self, "on_log_string")
		add_child(scene)
		move_child(scene, 0)
	elif OS.has_feature("client"):
		emit_signal("log_string", "Starting client...")
		var scene = client_scene.instance()
		scene.connect("log_string", self, "on_log_string")
		add_child(scene)
		move_child(scene, 0)
	else:
		emit_signal("log_string", "Starting client by default...")
		var scene = client_scene.instance()
#		emit_signal("log_string", "Starting server by default...")
#		var scene = server_scene.instance()
		scene.connect("log_string", self, "on_log_string")
		add_child(scene)
		move_child(scene, 0)
		
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func on_log_string(string):
	$Log.text += "\n" + string
	
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

remote func server_register_player_and_create_game(data):
	emit_signal("log_string", "server_register_player_and_create_game")
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.register_player_and_create_game(sender_id, data["player_name"], data["game_name"])
	rpc_id(sender_id, "client_register_player_and_create_game_response", response)
	
func client_register_player_and_create_game(data):
	emit_signal("log_string", "client_register_player_and_create_game")
	rpc_id(1, "server_register_player_and_create_game", data)
	
remote func client_register_player_and_create_game_response(status):
	emit_signal("log_string", "client_register_player_and_create_game_response")
	$ClientMain.on_receive_network_response("register_player_and_create_game", status)
	
remote func server_register_player_and_join_game(data):
	emit_signal("log_string", "server_register_player_and_join_game")
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.register_player_and_join_game(sender_id, data["player_name"], data["game_name"])
	rpc_id(sender_id, "client_register_player_and_join_game_response", response)
	
func client_register_player_and_join_game(data):
	emit_signal("log_string", "client_register_player_and_join_game")
	rpc_id(1, "server_register_player_and_join_game", data)
	
remote func client_register_player_and_join_game_response(status):
	emit_signal("log_string", "client_register_player_and_join_game_response")
	$ClientMain.on_receive_network_response("register_player_and_join_game", status)
	
remote func server_get_players(data):
	emit_signal("log_string", "server_get_players")
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.get_players(sender_id, data["game_name"])
	if response["status"] == "success":
		for player_id in response["player_ids"]:
			rpc_id(player_id, "client_get_players_response", response)
	else:
		rpc_id(sender_id, "client_get_players_response", response)
	
func client_get_players(data):
	emit_signal("log_string", "client_get_players")
	rpc_id(1, "server_get_players", data)
	
remote func client_get_players_response(data):
	emit_signal("log_string", "client_get_players_response")
	$ClientMain.on_receive_network_response("get_players", data)
	
remote func server_start_game(data):
	emit_signal("log_string", "server_start_game")
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.start_game(sender_id)
	for player_id in response["player_ids"]:
		rpc_id(player_id, "client_start_game_response", response)
	
func client_start_game(data):
	emit_signal("log_string", "client_start_game")
	rpc_id(1, "server_start_game", data)
	
remote func client_start_game_response(data):
	emit_signal("log_string", "client_start_game_response")
	$ClientMain.on_receive_network_response("start_game", data)
	
remote func server_get_player_order(data):
	emit_signal("log_string", "server_get_player_order")
	var sender_id = get_tree().get_rpc_sender_id()
	var response = $ServerMain.get_player_order(sender_id)
	rpc_id(sender_id, "client_get_player_order_response", response)
	
func client_get_player_order(data):
	emit_signal("log_string", "client_get_player_order")
	rpc_id(1, "server_get_player_order", data)
	
remote func client_get_player_order_response(data):
	emit_signal("log_string", "client_get_player_order_response")
	$ClientMain.on_receive_network_response("get_player_order", data)
