extends "res://client/State.gd"

func _ready():
	$UICanvasLayer/MenuPanel/StartButton.connect("pressed", self, "on_StartButton_pressed")

func on_StartButton_pressed():
	_state_machine.set_state("res://client/main_menu/MainMenuState.tscn")
