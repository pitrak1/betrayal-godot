extends Node

var __index = 0
var __count

func _init(count):
	__count = count
	
func get_index():
	return __index
	
func next():
	__index += 1
	if __index >= __count:
		__index = 0
		return true
	else:
		return false
	
func previous():
	__index -= 1
	if __index < 0:
		__index = __count - 1
		return true
	else:
		return false
