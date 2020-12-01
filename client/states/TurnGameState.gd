extends "res://client/State.gd"

func enter(custom_data):
	.enter(custom_data)
	add_child(_grid)
	$Grid.connect("change_game_state", self, "on_change_game_state")
	$RoomStack.setup()
	
func on_change_game_state(state_name, custom_data):
	emit_signal("log_string", "SOMETHING SOMETHING...")

