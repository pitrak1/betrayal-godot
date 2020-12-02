extends Node2D

signal activate(node)
signal select(node)

const __constants_script = preload("res://Constants.gd")
var _constants
var __actors = []
var grid_position

func _ready():
	_constants = __constants_script.new()
	
func setup(entry=null):
	_constants = __constants_script.new()
	
func has_door(direction):
	return true
	
func has_link(room):
	return true
	
func add_link(room):
	pass
	
func remove_link(room):
	pass

func _input(event):
	if event is InputEventMouseButton and is_in_bounds(event.global_position):
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			emit_signal("select", self)
		elif event.button_index == BUTTON_RIGHT and event.is_pressed():
			emit_signal("activate", self)
			
func is_in_bounds(position):
	for actor in __actors:
		if actor.is_in_bounds(position):
			return false
			
	var scaling_factor = 512 / 2 * global_scale.x
	var within_x_bounds = global_position.x - scaling_factor < position.x and position.x < global_position.x + scaling_factor
	var within_y_bounds = global_position.y - scaling_factor < position.y and position.y < global_position.y + scaling_factor
	return within_x_bounds and within_y_bounds
	
func set_position_and_rotation(grid_position, rotation=0):
	self.grid_position = grid_position
	self.position = Vector2(grid_position.x * _constants.tile_size, grid_position.y * _constants.tile_size)

func clear_position_and_rotation():
	grid_position = null
	rotation = 0
	
func select_handler(node):
	if node == self:
		$SelectedSprite.show()
	else:
		$SelectedSprite.hide()
