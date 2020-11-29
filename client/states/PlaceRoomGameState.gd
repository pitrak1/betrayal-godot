extends "res://common/State.gd"

func enter(custom_data):
	emit_signal("log_string", "Entering PlaceRoomGameState...")
	self.custom_data = custom_data
	add_child(custom_data["grid"])
	$Grid.connect("change_state", get_parent(), "on_change_state")
