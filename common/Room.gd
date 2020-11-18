extends Node2D

signal select(node)
signal activate(node)
var key	
var actors = []
var actor_positioning = [
	[],
	[Vector2(0, 0)],
	[Vector2(-100, 0), Vector2(100, 0)],
	[Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100)],
	[Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100), Vector2(100, 100)]
]
var doors = []
var links = []

func _ready():
	$SelectedSprite.hide()
	
func initialize(entry):
	self.name = entry["name"]
	self.key = entry["key"]
	self.doors = entry["doors"]

	$RoomSprite.region_enabled = true
	$RoomSprite.region_rect = Rect2(
		entry["index"].x * $Constants.tile_size, 
		entry["index"].y * $Constants.tile_size, 
		$Constants.tile_size, 
		$Constants.tile_size
	)
	__reorient_doors()
	
func add_actor(actor):
	actors.append(actor)
	add_child(actor)
	__reorient_actors()
	
func remove_actor(actor):
	actors.erase(actor)
	remove_child(actor)
	__reorient_actors()
	
func __reorient_actors():
	var positions = actor_positioning[actors.size()]
	for i in range(actors.size()):
		actors[i].position = positions[i]
		
func __reorient_doors():
	if doors[$Constants.UP]:
		$UpDoorSprite.show()
	else:
		$UpDoorSprite.hide()
		
	if doors[$Constants.RIGHT]:
		$RightDoorSprite.show()
	else:
		$RightDoorSprite.hide()
		
	if doors[$Constants.DOWN]:
		$DownDoorSprite.show()
	else:
		$DownDoorSprite.hide()
		
	if doors[$Constants.LEFT]:
		$LeftDoorSprite.show()
	else:
		$LeftDoorSprite.hide()
		

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
	for actor in actors:
		if actor.is_in_bounds(position):
			return false
		
	var scaling_factor = 512 / 2 * global_scale.x
	var within_x_bounds = global_position.x - scaling_factor < position.x and position.x < global_position.x + scaling_factor
	var within_y_bounds = global_position.y - scaling_factor < position.y and position.y < global_position.y + scaling_factor
	return within_x_bounds and within_y_bounds
	
func set_position_and_rotation(grid_position, rotation):
	self.position = Vector2(grid_position.x * $Constants.tile_size, grid_position.y * $Constants.tile_size)
	$RoomSprite.rotation = rotation
	for i in range(int(rotation / (PI/2))):
		doors.push_front(doors.pop_back())
	__reorient_doors()
	
		
