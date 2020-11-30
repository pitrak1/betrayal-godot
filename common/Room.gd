extends Node2D

signal select(node)
signal activate(node)

const __constants_script = preload("res://Constants.gd")

var __key	
var __actors = []
var __actor_positioning = [
	[],
	[Vector2(0, 0)],
	[Vector2(-100, 0), Vector2(100, 0)],
	[Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100)],
	[Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100), Vector2(100, 100)]
]
var __doors = []
var __links = []
var __constants

func get_key():
	return __key
	
func has_door(direction):
	return __doors[direction]
	
func add_link(room):
	__links.append(room)

func _ready():
	$SelectedSprite.hide()
	__constants = __constants_script.new()
	
func initialize(entry):
	__constants = __constants_script.new()
	name = entry["name"]
	__key = entry["key"]
	__doors = entry["doors"]

	$RoomSprite.region_enabled = true
	$RoomSprite.region_rect = Rect2(
		entry["index"].x * __constants.tile_size, 
		entry["index"].y * __constants.tile_size, 
		__constants.tile_size, 
		__constants.tile_size
	)
	__reorient_doors()
	
func add_actor(actor):
	__actors.append(actor)
	add_child(actor)
	__reorient_actors()
	
func remove_actor(actor):
	__actors.erase(actor)
	remove_child(actor)
	__reorient_actors()
	
func __reorient_actors():
	var positions = __actor_positioning[__actors.size()]
	for i in range(__actors.size()):
		__actors[i].position = positions[i]
		
func __reorient_doors():
	$UpDoorSprite.visible = __doors[__constants.UP]
	$RightDoorSprite.visible = __doors[__constants.RIGHT]
	$DownDoorSprite.visible = __doors[__constants.DOWN]
	$LeftDoorSprite.visible = __doors[__constants.LEFT]

func _input(event):
	if event is InputEventMouseButton and is_in_bounds(event.global_position):
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			emit_signal("select", self)
		elif event.button_index == BUTTON_RIGHT and event.is_pressed():
			emit_signal("activate", self)
			
func select_handler(node):
	if node == self:
		$SelectedSprite.show()
	else:
		$SelectedSprite.hide()
		
func is_in_bounds(position):
	for actor in __actors:
		if actor.is_in_bounds(position):
			return false
		
	var scaling_factor = 512 / 2 * global_scale.x
	var within_x_bounds = global_position.x - scaling_factor < position.x and position.x < global_position.x + scaling_factor
	var within_y_bounds = global_position.y - scaling_factor < position.y and position.y < global_position.y + scaling_factor
	return within_x_bounds and within_y_bounds
	
func set_position_and_rotation(grid_position, rotation):
	position = Vector2(grid_position.x * __constants.tile_size, grid_position.y * __constants.tile_size)
	$RoomSprite.rotation = rotation
	for _i in range(int(rotation / (PI/2))):
		__doors.push_front(__doors.pop_back())
	__reorient_doors()
	
		
