extends "res://client/State.gd"

func _ready():
	$UICanvasLayer/MenuPanel/HostButton.connect("pressed", self, "on_HostButton_pressed")
	$UICanvasLayer/MenuPanel/JoinButton.connect("pressed", self, "on_JoinButton_pressed")
	$UICanvasLayer/MenuPanel/ExitButton.connect("pressed", self, "on_ExitButton_pressed")

func on_HostButton_pressed():
	_global_context.player_info["host"] = true
	_state_machine.set_state("res://client/host_join_lobby/HostJoinLobbyState.tscn")
	
func on_JoinButton_pressed():
	_global_context.player_info["host"] = false
	_state_machine.set_state("res://client/host_join_lobby/HostJoinLobbyState.tscn")
	
func on_ExitButton_pressed():
	get_tree().quit()
