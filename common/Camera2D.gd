extends Camera2D

const __constants_script = preload("res://Constants.gd")

var __constants

func _ready():
	__constants = __constants_script.new()
	self.position = Vector2(
		__constants.starting_grid_position.x, 
		__constants.starting_grid_position.y
	) * __constants.tile_size + Vector2(640, 360)
	
func _process(_delta):
	var factor = Vector2()
	if Input.is_action_just_pressed("ui_right"):
		factor.x += 256
	if Input.is_action_just_pressed("ui_left"):
		factor.x -= 256
	if Input.is_action_just_pressed("ui_up"):
		factor.y -= 256
	if Input.is_action_just_pressed("ui_down"):
		factor.y += 256
	
	if factor.length():
		self.position += factor
		
	if Input.is_action_just_pressed("ui_zoom_out"):
		self.zoom -= Vector2(0.2, 0.2)
	if Input.is_action_just_pressed("ui_zoom_in"):
		self.zoom += Vector2(0.2, 0.2)
		
func center_on_grid_position(grid_position):
	self.position = grid_position * __constants.tile_size + Vector2(640, 360)
