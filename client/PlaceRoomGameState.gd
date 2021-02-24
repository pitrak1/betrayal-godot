extends "res://client/State.gd"

func enter(custom_data):
	.enter(custom_data)
	add_child(_grid)
	_grid.connect("change_state", get_parent(), "on_change_state")
