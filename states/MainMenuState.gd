extends "res://State.gd"

func enter():
	$Panel/HostButton.connect("pressed", self, "on_HostButton_pressed")
	$Panel/JoinButton.connect("pressed", self, "on_JoinButton_pressed")
	$Panel/ExitButton.connect("pressed", self, "on_ExitButton_pressed")

func on_HostButton_pressed():
	print("host")
	
func on_JoinButton_pressed():
	print("join")
	
func on_ExitButton_pressed():
	get_tree().quit()

func exit():
	pass

func handle_input(_event):
	pass

func physics_process(_delta):
	pass

func _on_animation_finished(_anim_name):
	pass
