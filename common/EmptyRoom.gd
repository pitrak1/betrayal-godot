extends Node2D

signal activate(node)

const __constants_script = preload("res://Constants.gd")

var __doors = [true, true, true, true]
var _constants

func _ready():
	_constants = __constants_script.new()
	
func has_door(direction):
	return __doors[direction]

func _input(event):
	if event is InputEventMouseButton and __is_in_bounds(event.global_position):
		if event.button_index == BUTTON_RIGHT and event.is_pressed():
			emit_signal("activate", self)
			
func __is_in_bounds(position):
	var scaling_factor = 512 / 2 * global_scale.x
	var within_x_bounds = global_position.x - scaling_factor < position.x and position.x < global_position.x + scaling_factor
	var within_y_bounds = global_position.y - scaling_factor < position.y and position.y < global_position.y + scaling_factor
	return within_x_bounds and within_y_bounds
	
func set_position_from_grid(grid_position):
	if not _constants:
		_constants = __constants_script.new()
	self.position = Vector2(grid_position.x * _constants.tile_size, grid_position.y * _constants.tile_size)
