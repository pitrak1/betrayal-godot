extends "res://common/State.gd"

func enter(custom_data):
	self.custom_data = custom_data
	add_child(custom_data["grid"])
