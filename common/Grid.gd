extends Node2D

const __room_script = preload("res://common/Room.gd")
const __empty_room_scene = preload("res://common/EmptyRoom.tscn")
const __constants_script = preload("res://Constants.gd")
var __rooms
var __selected
var __constants
var __current_state
	
func setup(room_stack):
	__constants = __constants_script.new()
	__initialize_rooms()
	__place_starting_rooms(room_stack)
	__setup_camera()
	
func __initialize_rooms():
	__rooms = []
	for i in range(__constants.grid_dimensions.x):
		__rooms.append([])
		for j in range(__constants.grid_dimensions.y):
			var empty_room = __empty_room_scene.instance()
			empty_room.setup()
			__rooms[i].append(false)
			place_room(empty_room, Vector2(i, j))
			
			
func __place_starting_rooms(room_stack):
	for starting_room in __constants.starting_rooms:
		var room = room_stack.get_by_key(starting_room["key"])
		place_room(room, starting_room["position"], starting_room["rotation"])
		
func __setup_camera():
	$Camera.connect("zoom", self, "on_Camera_zoom")
	$Camera.connect("pan", self, "on_Camera_pan")
	
func on_Camera_zoom(factor):
	var new_scale = clamp(scale.x + factor, 0.2, 2)
	scale = Vector2(new_scale, new_scale)
	
func on_Camera_pan(factor):
	position += factor * scale.x
	
func set_current_state(state):
	__current_state = state
	
func select_handler(node):
	__current_state.select_handler(node)
	
func activate_handler(node):
	__current_state.activate_handler(node)
		
func place_room(room, grid_position, rotation=0):
	if __rooms[grid_position.x][grid_position.y]:
		remove_room(grid_position, false)
	add_child(room)
	room.set_position_and_rotation(grid_position, rotation)
	__rooms[grid_position.x][grid_position.y] = room
	room.connect("select", self, "select_handler")
	room.connect("activate", self, "activate_handler")

	if grid_position.y > 0:
		var up_room = __rooms[grid_position.x][grid_position.y - 1]
		if up_room.has_door(__constants.DOWN) and room.has_door(__constants.UP):
			up_room.add_link(room)
			room.add_link(up_room)
			
	if grid_position.x < __rooms.size() - 1:
		var right_room = __rooms[grid_position.x + 1][grid_position.y]
		if right_room.has_door(__constants.LEFT) and room.has_door(__constants.RIGHT):
			right_room.add_link(room)
			room.add_link(right_room)
	
	if grid_position.y < __rooms[grid_position.x].size() - 1:
		var down_room = __rooms[grid_position.x][grid_position.y + 1]
		if down_room.has_door(__constants.UP) and room.has_door(__constants.DOWN):
			down_room.add_link(room)
			room.add_link(down_room)
	
	if grid_position.x > 0:
		var left_room = __rooms[grid_position.x - 1][grid_position.y]
		if left_room.has_door(__constants.RIGHT) and room.has_door(__constants.LEFT):
			left_room.add_link(room)
			room.add_link(left_room)
	
func remove_room(grid_position, replace_with_empty=true):
	var room = __rooms[grid_position.x][grid_position.y]
	
	if grid_position.y < __rooms[grid_position.x].size() - 1:
		var up_room = __rooms[grid_position.x][grid_position.y - 1]
		up_room.remove_link(room)
		room.remove_link(up_room)
	
	if grid_position.x < __rooms.size() - 1:
		var right_room = __rooms[grid_position.x + 1][grid_position.y]
		right_room.remove_link(room)
		room.remove_link(right_room)
				
	if grid_position.y < __rooms[grid_position.x].size() - 1:
		var down_room = __rooms[grid_position.x][grid_position.y + 1]
		down_room.remove_link(room)
		room.remove_link(down_room)
			
	if grid_position.x > 0:	
		var left_room = __rooms[grid_position.x + 1][grid_position.y]
		left_room.remove_link(room)
		room.remove_link(left_room)
			
	remove_child(room)
	room.clear_position_and_rotation()
	__rooms[grid_position.x][grid_position.y] = null
	room.disconnect("select", self, "select_handler")
	room.disconnect("activate", self, "activate_handler")
	
	if replace_with_empty:
		var empty_room = __empty_room_scene.instance()
		empty_room.setup()
		place_room(empty_room, grid_position)
	
	return room
	
func place_actor(actor, grid_position):
	var room = __rooms[grid_position.x][grid_position.y]
	assert(room is __room_script)
	room.add_actor(actor)
	actor.connect("select", self, "select_handler")
	actor.connect("activate", self, "activate_handler")

func remove_actor(actor, grid_position):
	var room = __rooms[grid_position.x][grid_position.y]
	assert(room is __room_script)
	assert(room.has_actor(actor))
	room.remove_actor(actor)
	actor.disconnect("select", self, "select_handler")
	actor.disconnect("activate", self, "activate_handler")
	
func get_room(grid_position):
	return __rooms[grid_position.x][grid_position.y]
