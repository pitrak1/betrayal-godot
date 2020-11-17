extends Node

var current_state = null
var custom_data = {}

func _ready():
	__change_state(get_child(0).name)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func on_change_state(state_name, custom_data):
	for key in custom_data.keys():
		self.custom_data[key] = custom_data[key]
	__change_state(state_name)
	
func __change_state(state_name):
	if current_state:
		current_state.hide()
		current_state.disconnect("change_state", self, "on_change_state")
		current_state.exit()
	current_state = find_node(state_name)
	current_state.show()
	current_state.connect("change_state", self, "on_change_state")
	current_state.enter(custom_data)
	
func _unhandled_input(event):
	current_state.handle_input(event)

func _physics_process(delta):
	current_state.physics_process(delta)

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	print("player_connected")
	rpc_id(id, "register_player", custom_data)

func _player_disconnected(id):
	print("player_disconnected")
	custom_data["players"].erase(id) # Erase player from info.
	current_state.update_custom_data(self.custom_data)

func _connected_ok():
	print("connected_ok")
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	print("server_disconnected")
	pass # Server kicked us; show error and abort.

func _connected_fail():
	print("connected_fail")
	pass # Could not even connect to server; abort.

remote func register_player(custom_data):
	print("register_player")
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	self.custom_data["players"][id] = { 
		"player_name": custom_data["player_name"],
		"host": custom_data["host"]
	}
	current_state.update_custom_data(self.custom_data)

	# Call function to update lobby UI here
