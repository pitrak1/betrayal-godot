extends Node2D

var _global_context
var _state_machine
var _network
var _constants

func _ready():
	_global_context = get_node("/root/GlobalContext")
	_state_machine = get_node("/root/StateMachine")
	_network = get_node("/root/Network")
	_constants = get_node("/root/Constants")

	self._log("Entered state " + self.name)
	$UICanvasLayer/LoadingLabel.visible = false
	$Camera2D.make_current()
	
func _log(string):
	_global_context.log_contents += string + "\n"
	$UICanvasLayer/Log.text = _global_context.log_contents
	
func send_network_command(command_type, data):
	_log("Sending " + command_type + " command...")
	_network.client_handle_outgoing_network_command(command_type, data)
	$UICanvasLayer/LoadingLabel.visible = true
	
func on_receive_network_response(command_type, data):
	_log("Handling " + command_type + " response with status " + data['status'] + "...")
	self.call(command_type + "_response", data)
	$UICanvasLayer/LoadingLabel.visible = false
