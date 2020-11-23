extends Node

signal log_string(string)

var client_scene = preload("res://client/ClientMain.tscn")
var server_scene = preload("res://server/ServerMain.tscn")

func _ready():
	connect("log_string", self, "on_log_string")
	emit_signal("log_string", "Application started!")
	
	if OS.has_feature("server"):
		emit_signal("log_string", "Starting server...")
		__create_scene(server_scene)
	elif OS.has_feature("client"):
		emit_signal("log_string", "Starting client...")
		__create_scene(client_scene)
	else:
		emit_signal("log_string", "Starting client by default...")
		__create_scene(client_scene)
#		emit_signal("log_string", "Starting server by default...")
#		__create_scene(server_scene)
		
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func __create_scene(scene):
	var scene_instance = scene.instance()
	scene_instance.connect("log_string", self, "on_log_string")
	add_child(scene_instance)
	move_child(scene_instance, 0)
	
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
	
	
# A result from the $ServerMain object has three things:
# - response_type to tell who should be responded to
# - response to actually send
# - players for use when broadcasting to every player in a game

remote func server_handle_incoming_network_command(command_type, data):
	emit_signal("log_string", "Handling " + command_type + " command...")
	var sender_id = get_tree().get_rpc_sender_id()
	var result = $ServerMain.call(command_type, sender_id, data)
	if result["response_type"] == "return":
		rpc_id(sender_id, "client_handle_incoming_network_response", command_type, result["response"])
	elif result["response_type"] == "broadcast":
		for player in result["players"]:
			rpc_id(player.id, "client_handle_incoming_network_response", command_type, result["response"])
			
func client_handle_outgoing_network_command(command_type, data):
	emit_signal("log_string", "Sending " + command_type + " command...")
	rpc_id(1, "server_handle_incoming_network_command", command_type, data)
	
remote func client_handle_incoming_network_response(command_type, data):
	emit_signal("log_string", "Handling " + command_type + " response...")
	$ClientMain.on_receive_network_response(command_type, data)
	
