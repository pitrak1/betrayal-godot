extends CanvasItem

signal change_state(state_name, custom_data)

var custom_data

func enter(custom_data):
	custom_data = custom_data

func exit():
	pass

func handle_input(_event):
	pass

func physics_process(_delta):
	pass

func _on_animation_finished(_anim_name):
	pass
	
func update_custom_data(custom_data):
	custom_data = custom_data
