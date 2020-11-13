extends Node

export (PackedScene) var Room
var stack = []

func _ready():
	for r in $Constants.rooms:
		var room = Room.instance()
		room.name = r["name"]
		room.key = r["key"]
		room.region_enabled = true
		room.region_rect = Rect2(
			r["index"].x * $Constants.tile_size, 
			r["index"].y * $Constants.tile_size, 
			$Constants.tile_size, 
			$Constants.tile_size
		)
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


