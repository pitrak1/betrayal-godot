extends Node

const __room_scene = preload("res://common/Room.tscn")
const __constants_script = preload("res://Constants.gd")
var __stack = []
var __constants
	
func setup():
	__constants = __constants_script.new()
	for r in __constants.rooms:
		var room = __room_scene.instance()
		room.setup(r)
		__stack.append(room)
	__stack.shuffle()
		
func get_by_key(key):
	var room
	for r in __stack:
		if key == r.key:
			room = r
			break
	__stack.erase(room)
	return room
	
func get_next():
	return __stack.pop_front()


