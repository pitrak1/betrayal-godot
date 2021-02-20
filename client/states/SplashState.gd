extends "res://client/State.gd"

func _ready():
	$UICanvasLayer/MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")

func on_StartButton_pressed():
	_log("Handling StartButton pressed...")
	_state_machine.goto_scene("res://client/states/MainMenuState.tscn")
