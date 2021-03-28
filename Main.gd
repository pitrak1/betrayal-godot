extends Node2D

var __global_context
var __state_machine

func _ready():
	randomize()
	__global_context = get_node("/root/GlobalContext")
	__state_machine = get_node("/root/StateMachine")
	
	if OS.has_feature("server"):
		__start_server()
	elif OS.has_feature("client"):
		__start_client()
	elif __global_context.player_info["network_role"] == "server":
		__start_server()
	else:
		__start_client()
		
func __start_client():
	__state_machine.set_state("res://client/debug/DebugState.tscn")

func __start_server():
	__state_machine.set_state("res://server/ServerMain.tscn")
