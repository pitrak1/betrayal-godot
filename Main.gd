extends Node2D

func _ready():
	var global_context = get_node("/root/GlobalContext")
	var state_machine = get_node("/root/StateMachine")
	if OS.has_feature("server"):
		__start_server(state_machine)
	elif OS.has_feature("client"):
		__start_client(state_machine)
	elif global_context.player_info["network_role"] == "server":
		__start_server(state_machine)
	else:
		__start_client(state_machine)
		
func __start_client(state_machine):
	state_machine.goto_scene("res://client/states/SplashState.tscn")

func __start_server(state_machine):
	state_machine.goto_scene("res://server/ServerMain.tscn")
