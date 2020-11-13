extends Node

signal zoom(factor)
signal pan(factor)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP:
		emit_signal("zoom", 0.2)
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN:
		emit_signal("zoom", -0.2)
	
func _process(delta):
	var factor = Vector2()
	if Input.is_action_just_pressed("ui_right"):
		factor.x -= $Constants.tile_size
	if Input.is_action_just_pressed("ui_left"):
		factor.x += $Constants.tile_size
	if Input.is_action_just_pressed("ui_up"):
		factor.y += $Constants.tile_size
	if Input.is_action_just_pressed("ui_down"):
		factor.y -= $Constants.tile_size
	
	if factor.length():
		emit_signal("pan", factor)
