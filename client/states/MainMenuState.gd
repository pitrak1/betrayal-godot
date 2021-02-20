extends "res://client/State.gd"

func _ready():
	$UICanvasLayer/MenuPanel/HostButton.connect("pressed", self, "on_HostButton_pressed")
	$UICanvasLayer/MenuPanel/JoinButton.connect("pressed", self, "on_JoinButton_pressed")
	$UICanvasLayer/MenuPanel/ExitButton.connect("pressed", self, "on_ExitButton_pressed")

func on_HostButton_pressed():
	_log("Handling HostButton pressed...")
	_global_context.player_info["host"] = true
	_state_machine.goto_scene("res://client/states/HostJoinGameState.tscn")
	
func on_JoinButton_pressed():
	_log("Handling JoinButton pressed...")
	_global_context.player_info["host"] = false
	_state_machine.goto_scene("res://client/states/HostJoinGameState.tscn")
	
func on_ExitButton_pressed():
	_log("Handling ExitBUtton pressed...")
	get_tree().quit()
