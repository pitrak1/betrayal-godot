extends "res://client/State.gd"

const __actor_script = preload("res://common/Actor.gd")
const __room_script = preload("res://common/Room.gd")
const __empty_room_scene = preload("res://common/EmptyRoom.tscn")
const __empty_room_script = preload("res://common/EmptyRoom.gd")

var __selected

func enter(custom_data):
	.enter(custom_data)
	add_child(_grid)
	_grid.set_current_state(self)
	add_child(_room_stack)
	
func select_handler(node):
	__selected = node
	get_tree().call_group("selectable", "select_handler", node)

func activate_handler(node):
	if __selected is __actor_script:
		var start_room_position = __selected.grid_position
		var end_room_position = node.grid_position
		move_actor(__selected, start_room_position, end_room_position)
		
func move_actor(actor, start_grid_position, end_grid_position):
	var start_room = _grid.get_room(start_grid_position)
	var end_room = _grid.get_room(end_grid_position)
	assert(start_room is __room_script)
	assert(start_room.has_actor(actor))
	assert(start_room.has_link(end_room) or start_room == end_room)
	if not end_room is __room_script:
		print("TEST TEST TEST")
#		emit_signal("change_game_state", "PlaceRoomGameState", { "position": end_grid_position })
	else:
		_grid.remove_actor(actor, start_grid_position)
		_grid.place_actor(actor, end_grid_position)
