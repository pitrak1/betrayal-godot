extends "res://client/State.gd"

#const __actor_script = preload("res://common/Actor.gd")
#const __room_script = preload("res://common/Room.gd")
#const __empty_room_scene = preload("res://common/EmptyRoom.tscn")
#const __empty_room_script = preload("res://common/EmptyRoom.gd")

var __selected

func _ready():
	print(_global_context)
	print(_global_context.player_info)
	$Camera2D.center_on_grid_position(Vector2(3, 3))
	add_child(_global_context.grid_info['room_stack'])
	add_child(_global_context.grid_info['grid'])
	print(get_node("Grid").get_child_count())
#	__setup_game.setup(__players)
#	var grid = _global_context.player_info["grid"]
#	add_child(grid)
#	grid.set_current_state(self)
#	add_child(_global_context.player_info["room_stack"])
#
#func select_handler(node):
#	__selected = node
#	get_tree().call_group("selectable", "select_handler", node)
#
#func activate_handler(node):
#	if __selected is __actor_script and node is __room_script:
#		move_actor(__selected, __selected.grid_position, node.grid_position)
#
#func move_actor(actor, start_grid_position, end_grid_position):
#	var start_room = _global_context.player_info["grid"].get_room(start_grid_position)
#	var end_room = _global_context.player_info["grid"].get_room(end_grid_position)
#	assert(start_room.has_actor(actor))
#	assert(start_room.has_link(end_room) or start_room == end_room)
#	if not end_room is __room_script:
#		print("TEST TEST TEST")
##		emit_signal("change_game_state", "PlaceRoomGameState", { "position": end_grid_position })
#	else:
#		send_network_command("move_actor", { "start_grid_position": start_grid_position, "actor_key": actor.key, "end_grid_position": end_grid_position })
#
#func move_actor_response(response):
#	var start_room = _global_context.player_info["grid"].get_room(response["start_grid_position"])
#	var actor = start_room.get_actor_by_key(response["actor_key"])
#	_global_context.player_info["grid"].remove_actor(actor, response["start_grid_position"])
#	_global_context.player_info["grid"].place_actor(actor, response["end_grid_position"])
