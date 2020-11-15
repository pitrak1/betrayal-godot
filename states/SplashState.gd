extends "res://State.gd"

signal change_state(state_name)

func enter():
	$Panel/StartButton.connect("pressed", self, "on_StartButton_pressed")

func on_StartButton_pressed():
	emit_signal("change_state", "MainMenuState")

func exit():
	pass

func handle_input(_event):
	pass

func physics_process(_delta):
	pass

func _on_animation_finished(_anim_name):
	pass
