extends Node2D

signal activate(node)
signal select(node)

const __constants_script = preload("res://Constants.gd")
var _constants
var __actors = []
var grid_position

func _ready():
	_constants = __constants_script.new()
	
func setup(_entry=null):
	_constants = __constants_script.new()
	
func has_door(_direction):
	return true
	
func has_link(_room):
	return true
	
func add_link(_room):
	pass
	
func remove_link(_room):
	pass

func _input(event):
	if event is InputEventMouseButton and is_in_bounds(event.position):
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			print('test')
			emit_signal("select", self)
		elif event.button_index == BUTTON_RIGHT and event.is_pressed():
			emit_signal("activate", self)
			
func is_in_bounds(position):
	for actor in __actors:
		if actor.is_in_bounds(position):
			return false

	var camera_position = get_tree().get_current_scene().get_node("Camera2D").position
	var viewport_size = get_viewport_rect().size
	var adjusted_position = camera_position - viewport_size / 2 + position

	var room_size = 512 / 2
	var within_x_bounds = global_position.x - room_size < adjusted_position.x and adjusted_position.x < global_position.x + room_size
	var within_y_bounds = global_position.y - room_size < adjusted_position.y and adjusted_position.y < global_position.y + room_size
	return within_x_bounds and within_y_bounds
	
func set_position_and_rotation(grid_pos, _rotation=0):
	self.grid_position = grid_pos
	self.position = Vector2(grid_pos.x * _constants.tile_size, grid_pos.y * _constants.tile_size)

func clear_position_and_rotation():
	grid_position = null
	rotation = 0
	
func select_handler(node):
	if node == self:
		$SelectedSprite.show()
	else:
		$SelectedSprite.hide()
