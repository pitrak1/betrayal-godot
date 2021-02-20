extends Node

var _constants

func _ready():
	_constants = get_node("/root/Constants")
	var global_context = get_node("/root/GlobalContext")
	if OS.has_feature("server"):
		__start_server()
	elif OS.has_feature("client"):
		__start_client()
	elif global_context.testing == false:
		if global_context.player_info["network_role"] == "server":
			__start_server()
		else:
			__start_client()
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func __start_client():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(_constants.ip_address, _constants.port)
	get_tree().network_peer = peer

func __start_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(_constants.port, 6)
	get_tree().network_peer = peer

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
	var sender_id = get_tree().get_rpc_sender_id()
	var result = __get_current_scene().handle_incoming_network_command(command_type, sender_id, data)
	if result["response_type"] == "return":
		rpc_id(sender_id, "client_handle_incoming_network_response", command_type, result["response"])
	elif result["response_type"] == "broadcast":
		for player in result["players"]:
			rpc_id(player.get_id(), "client_handle_incoming_network_response", command_type, result["response"])

func client_handle_outgoing_network_command(command_type, data):
	rpc_id(1, "server_handle_incoming_network_command", command_type, data)

remote func client_handle_incoming_network_response(command_type, data):
	__get_current_scene().on_receive_network_response(command_type, data)
	
func __get_current_scene():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)
