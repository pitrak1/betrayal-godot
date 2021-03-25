extends "res://common/EmptyRoom.gd"

var key	
var __actor_positioning = [
	[],
	[Vector2(0, 0)],
	[Vector2(-100, 0), Vector2(100, 0)],
	[Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100)],
	[Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100), Vector2(100, 100)]
]
var __doors = []
var __links = []

func setup(entry=null):
	_constants = __constants_script.new()
	name = entry["name"]
	key = entry["key"]
	__doors = entry["doors"].duplicate()

	$RoomSprite.region_enabled = true
	$RoomSprite.region_rect = Rect2(
		entry["index"].x * _constants.tile_size, 
		entry["index"].y * _constants.tile_size, 
		_constants.tile_size, 
		_constants.tile_size
	)
	__display_doors()
	
func has_door(direction):
	return __doors[direction]
	
func has_link(room):
	return room in __links
	
func add_link(room):
	__links.append(room)
	
func remove_link(room):
	__links.erase(room)
	
func __display_doors():
	$UpDoorSprite.visible = __doors[_constants.UP]
	$RightDoorSprite.visible = __doors[_constants.RIGHT]
	$DownDoorSprite.visible = __doors[_constants.DOWN]
	$LeftDoorSprite.visible = __doors[_constants.LEFT]
	
func add_actor(actor):
	__actors.append(actor)
	add_child(actor)
	actor.grid_position = grid_position
	__position_actors()
	
func remove_actor(actor):
	__actors.erase(actor)
	remove_child(actor)
	actor.grid_position = null
	__position_actors()
	
func has_actor(actor):
	return actor in __actors
	
func get_actor_by_key(k):
	for actor in __actors:
		if actor.key == k:
			return actor
	return null
	
func __position_actors():
	var positions = __actor_positioning[__actors.size()]
	for i in range(__actors.size()):
		__actors[i].position = positions[i]
	
func set_position_and_rotation(grid_position, rotation=0):
	.set_position_and_rotation(grid_position, rotation)
	$RoomSprite.rotation = rotation
	for _i in range(int(rotation / (PI/2))):
		__doors.push_front(__doors.pop_back())
	__display_doors()

