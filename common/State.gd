extends CanvasItem

signal log_string(string)
signal change_state(state_name, custom_data)
signal send_network_command(command_name, data)

var custom_data

func enter(custom_data):
	pass

func exit():
	pass

func handle_input(_event):
	pass

func physics_process(_delta):
	pass

func _on_animation_finished(_anim_name):
	pass
