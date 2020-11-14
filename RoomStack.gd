extends Node

export (PackedScene) var Room
var stack = []

func _ready():
	for r in $Constants.rooms:
		var room = Room.instance()
		room.initialize(r)
		stack.append(room)
	stack.shuffle()
		
func get_by_key(key):
	var room
	for r in stack:
		if key == r.key:
			room = r
			break
	stack.erase(room)
	return room
	
func get_next():
	return stack.pop_front()


