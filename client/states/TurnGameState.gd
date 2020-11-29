extends "res://common/State.gd"

func enter(custom_data):
	emit_signal("log_string", "Entering TurnGameState...")
	self.custom_data = custom_data
	add_child(custom_data["grid"])
	$Grid.connect("change_game_state", self, "on_change_game_state")
	
func on_change_game_state(state_name, custom_data):
	emit_signal("log_string", "SOMETHING SOMETHING...")

