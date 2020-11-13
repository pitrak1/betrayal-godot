extends Node2D

export (PackedScene) var Player
var room_resource
var room_entries
var rooms
var selected

func _ready():
	room_entries = $Constants.rooms
	__initialize_rooms()
	__place_starting_rooms()
	__setup_camera()
	rooms[0][0].add_actor(Player.instance())
	
func __initialize_rooms():
	rooms = []
	for i in range($Constants.grid_dimensions.x):
		rooms.append([])
		for j in range($Constants.grid_dimensions.y):
			rooms[i].append(false)
			
func __place_starting_rooms():
	for starting_room in $Constants.starting_rooms:
		place_room($RoomStack.get_by_key(starting_room["key"]), starting_room["position"], starting_room["rotation"])
		
func __setup_camera():
	$Camera.connect("zoom", self, "_on_Camera_zoom")
	$Camera.connect("pan", self, "_on_Camera_pan")
	
func _on_Camera_zoom(factor):
	var new_scale = clamp(scale.x + factor, 0.2, 2)
	scale = Vector2(new_scale, new_scale)
	
func _on_Camera_pan(factor):
	position += factor * scale.x
		
func select_handler(node):
	get_tree().call_group("selectable", "select_handler", node)
		
func place_room(room, grid_position, rotation=0):
	assert(!rooms[grid_position.x][grid_position.y])
	add_child(room)
	room.position = Vector2(grid_position.x * $Constants.tile_size, grid_position.y * $Constants.tile_size)
	room.rotation = rotation
	rooms[grid_position.x][grid_position.y] = room
	room.connect("select", self, "select_handler")

	
	

