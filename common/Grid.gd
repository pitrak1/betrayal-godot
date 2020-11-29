extends Node2D

signal change_game_state(state_name, custom_data)

export (PackedScene) var ActorScene
const Room = preload("res://common/Room.gd")
const empty_room_script = preload("res://common/EmptyRoom.gd")
const empty_room_scene = preload("res://common/EmptyRoom.tscn")
const Actor = preload("res://common/Actor.gd")
var room_resource
var room_entries
var rooms
var selected
	
func setup():
	room_entries = $Constants.rooms
	__setup_stack()
	__initialize_rooms()
	__place_starting_rooms()
	__setup_camera()
	
func __setup_stack():
	$RoomStack.setup()
	
func __initialize_rooms():
	rooms = []
	for i in range($Constants.grid_dimensions.x):
		rooms.append([])
		for j in range($Constants.grid_dimensions.y):
			rooms[i].append(false)
			place_empty_room(Vector2(i, j))
			
func __place_starting_rooms():
	for starting_room in $Constants.starting_rooms:
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
	selected = node
	get_tree().call_group("selectable", "select_handler", node)

func activate_handler(node):
	if selected is Actor:
		var start_room_position
		for i in range($Constants.grid_dimensions.x):
			for j in range($Constants.grid_dimensions.y):
				if rooms[i][j] is Room and selected in rooms[i][j].actors:
					start_room_position = Vector2(i, j)
					break
					
		var end_room_position
		for i in range($Constants.grid_dimensions.x):
			for j in range($Constants.grid_dimensions.y):
				if node == rooms[i][j]:
					end_room_position = Vector2(i, j)
					break
		move_actor(selected, start_room_position, end_room_position)
		
func place_empty_room(grid_position):
	var room = empty_room_scene.instance()
	add_child(room)
	room.set_position_from_grid(grid_position)
	rooms[grid_position.x][grid_position.y] = room
	room.connect("activate", self, "activate_handler")
		
func place_room(room, grid_position, rotation=0):
	assert(rooms[grid_position.x][grid_position.y] is empty_room_script)
	remove_child(rooms[grid_position.x][grid_position.y])
	add_child(room)
	room.set_position_and_rotation(grid_position, rotation)
	rooms[grid_position.x][grid_position.y] = room
	room.connect("select", self, "select_handler")
	room.connect("activate", self, "activate_handler")
	
	var up_room = rooms[grid_position.x][grid_position.y - 1]
	if up_room.doors[$Constants.DOWN] and room.doors[$Constants.UP]:
		if up_room is Room: 
			up_room.links.append(room)
		room.links.append(up_room)
			
	var right_room = rooms[grid_position.x + 1][grid_position.y]
	if right_room.doors[$Constants.LEFT] and room.doors[$Constants.RIGHT]:
		if right_room is Room:
			right_room.links.append(room)
		room.links.append(right_room)
			
	var down_room = rooms[grid_position.x][grid_position.y + 1]
	if down_room.doors[$Constants.UP] and room.doors[$Constants.DOWN]:
		if down_room is Room:
			down_room.links.append(room)
		room.links.append(down_room)
			
	var left_room = rooms[grid_position.x + 1][grid_position.y]
	if left_room.doors[$Constants.RIGHT] and room.doors[$Constants.LEFT]:
		if left_room is Room:
			left_room.links.append(room)
		room.links.append(left_room)
	
func place_actor(actor, grid_position):
	assert(rooms[grid_position.x][grid_position.y])
	rooms[grid_position.x][grid_position.y].add_actor(actor)
	actor.connect("select", self, "select_handler")
	
func move_actor(actor, start_grid_position, end_grid_position):
	var start_room = rooms[start_grid_position.x][start_grid_position.y]
	var end_room = rooms[end_grid_position.x][end_grid_position.y]
	assert(start_room is Room)
	assert(actor in start_room.actors)
	assert(end_room in start_room.links)
	if end_room is empty_room_script:
		emit_signal("change_game_state", "PlaceRoomGameState", { "position": end_grid_position })
	else:
		start_room.remove_actor(actor)
		end_room.add_actor(actor)
	
