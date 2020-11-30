extends Node

# warning-ignore:unused_signal
signal log_string(string)

var __current_state = null
var __custom_data = {}

func _ready():
	__change_state(get_child(0).name)

func on_change_state(state_name, custom_data):
	for key in custom_data.keys():
		__custom_data[key] = custom_data[key]
	__change_state(state_name)
	
func on_send_network_command(command_type, data):
	get_parent().call("client_handle_outgoing_network_command", command_type, data)
	$LoadingLabel.visible = true
	
func on_receive_network_response(command_type, data):
	var method_name = command_type + "_response"
	__current_state.call(method_name, data)
	$LoadingLabel.visible = false
	
func __change_state(state_name):
	if __current_state:
		__current_state.hide()
		__current_state.disconnect("change_state", self, "on_change_state")
		__current_state.disconnect("send_network_command", self, "on_send_network_command")
		__current_state.disconnect("log_string", get_parent(), "on_log_string")
		__current_state.exit()
	__current_state = find_node(state_name)
	__current_state.show()
	__current_state.connect("change_state", self, "on_change_state")
	__current_state.connect("send_network_command", self, "on_send_network_command")
	__current_state.connect("log_string", get_parent(), "on_log_string")
	__current_state.enter(__custom_data)
	
func _unhandled_input(event):
	__current_state.handle_input(event)

func _physics_process(delta):
	__current_state.physics_process(delta)

func _on_animation_finished(anim_name):
	__current_state._on_animation_finished(anim_name)
	
