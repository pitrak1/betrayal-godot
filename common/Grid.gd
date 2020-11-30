extends Node2D

signal change_game_state(state_name, custom_data)

const __actor_scene = preload("res://common/Actor.tscn")
const __actor_script = preload("res://common/Actor.gd")
const __room_script = preload("res://common/Room.gd")
const __empty_room_scene = preload("res://common/EmptyRoom.tscn")
const __empty_room_script = preload("res://common/EmptyRoom.gd")
const __constants_script = preload("res://Constants.gd")
var __room_entries
var __rooms
var __selected
var __constants
	
func setup():
	__constants = __constants_script.new()
	__room_entries = __constants.rooms.duplicate()
	$RoomStack.setup()
	__initialize_rooms()
	__place_starting_rooms()
	__setup_camera()
	
func __initialize_rooms():
	__rooms = []
	for i in range(__constants.grid_dimensions.x):
		__rooms.append([])
		for j in range(__constants.grid_dimensions.y):
			__rooms[i].append(false)
			place_empty_room(Vector2(i, j))
			
func __place_starting_rooms():
	for starting_room in __constants.starting_rooms:
		var room = $RoomStack.get_by_key(starting_room["key"])
		place_room(room, starting_room["position"], starting_room["rotation"])
		
func __setup_camera():
	$Camera.connect("zoom", self, "_on_Camera_zoom")
	$Camera.connect("pan", self, "_on_Camera_pan")
	
func _on_Camera_zoom(factor):
	var new_scale = clamp(scale.x + factor, 0.2, 2)
	scale = Vector2(new_scale, new_scale)
	
func _on_Camera_pan(factor):
	position += factor * scale.x
		
func select_handler(node):
	__selected = node
	get_tree().call_group("selectable", "select_handler", node)

func activate_handler(node):
	if __selected is __actor_script:
		var start_room_position
		for i in range(__constants.grid_dimensions.x):
			for j in range(__constants.grid_dimensions.y):
				if __rooms[i][j] is __room_script and __selected in __rooms[i][j].actors:
					start_room_position = Vector2(i, j)
					break
					
		var end_room_position
		for i in range(__constants.grid_dimensions.x):
			for j in range(__constants.grid_dimensions.y):
				if node == __rooms[i][j]:
					end_room_position = Vector2(i, j)
					break
		move_actor(__selected, start_room_position, end_room_position)
		
func place_empty_room(grid_position):
	var room = __empty_room_scene.instance()
	add_child(room)
	room.set_position_from_grid(grid_position)
	__rooms[grid_position.x][grid_position.y] = room
	room.connect("activate", self, "activate_handler")
		
func place_room(room, grid_position, rotation=0):
	assert(__rooms[grid_position.x][grid_position.y] is __empty_room_script)
	remove_child(__rooms[grid_position.x][grid_position.y])
	add_child(room)
	room.set_position_and_rotation(grid_position, rotation)
	__rooms[grid_position.x][grid_position.y] = room
	room.connect("select", self, "select_handler")
	room.connect("activate", self, "activate_handler")
	
	var up_room = __rooms[grid_position.x][grid_position.y - 1]
	if up_room.has_door(__constants.DOWN) and room.has_door(__constants.UP):
		if up_room is __room_script: 
			up_room.add_link(room)
		room.add_link(up_room)
			
	var right_room = __rooms[grid_position.x + 1][grid_position.y]
	if right_room.has_door(__constants.LEFT) and room.has_door(__constants.RIGHT):
		if right_room is __room_script:
			right_room.add_link(room)
		room.add_link(right_room)
			
	var down_room = __rooms[grid_position.x][grid_position.y + 1]
	if down_room.has_door(__constants.UP) and room.has_door(__constants.DOWN):
		if down_room is __room_script:
			down_room.add_link(room)
		room.add_link(down_room)
			
	var left_room = __rooms[grid_position.x + 1][grid_position.y]
	if left_room.has_door(__constants.RIGHT) and room.has_door(__constants.LEFT):
		if left_room is __room_script:
			left_room.add_link(room)
		room.add_link(left_room)
	
func place_actor(actor, grid_position):
	assert(__rooms[grid_position.x][grid_position.y])
	__rooms[grid_position.x][grid_position.y].add_actor(actor)
	actor.connect("select", self, "select_handler")
	
func move_actor(actor, start_grid_position, end_grid_position):
	var start_room = __rooms[start_grid_position.x][start_grid_position.y]
	var end_room = __rooms[end_grid_position.x][end_grid_position.y]
	assert(start_room is __room_script)
	assert(actor in start_room.actors)
	assert(end_room in start_room.links)
	if end_room is __empty_room_script:
		emit_signal("change_game_state", "PlaceRoomGameState", { "position": end_grid_position })
	else:
		start_room.remove_actor(actor)
		end_room.add_actor(actor)
	
