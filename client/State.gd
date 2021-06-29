extends "res://addons/ProjectBootstrap/State.gd"

var _global_context
var _state_machine
var _constants

func _ready():
	_global_context = get_node("/root/GlobalContext")
	_state_machine = get_node("/root/StateMachine")
	_constants = get_node("/root/Constants")
