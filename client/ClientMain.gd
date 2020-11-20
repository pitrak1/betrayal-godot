extends Node

signal log_string(string)

var current_state = null
var custom_data = {}

func _ready():
	__change_state(get_child(0).name)

func on_change_state(state_name, custom_data):
	for key in custom_data.keys():
		self.custom_data[key] = custom_data[key]
	__change_state(state_name)
	
func on_send_network_command(command_type, data):
	get_parent().call("client_handle_outgoing_network_command", command_type, data)
	$LoadingLabel.visible = true
	
func on_receive_network_response(command_type, data):
	var method_name = command_type + "_response"
	current_state.call(method_name, data)
	$LoadingLabel.visible = false
	
func __change_state(state_name):
	if current_state:
		current_state.hide()
		current_state.disconnect("change_state", self, "on_change_state")
		current_state.disconnect("send_network_command", self, "on_send_network_command")
		current_state.disconnect("log_string", get_parent(), "on_log_string")
		current_state.exit()
	current_state = find_node(state_name)
	current_state.show()
	current_state.connect("change_state", self, "on_change_state")
	current_state.connect("send_network_command", self, "on_send_network_command")
	current_state.connect("log_string", get_parent(), "on_log_string")
	current_state.enter(custom_data)
	
func _unhandled_input(event):
	current_state.handle_input(event)

func _physics_process(delta):
	current_state.physics_process(delta)

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)
	
