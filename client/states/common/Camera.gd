extends Node

signal zoom(factor)
signal pan(factor)

const __constants_script = preload("res://Constants.gd")
var __constants

func _ready():
	__constants = __constants_script.new()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP:
		emit_signal("zoom", 0.2)
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN:
		emit_signal("zoom", -0.2)
	
func _process(_delta):
	var factor = Vector2()
	if Input.is_action_just_pressed("ui_right"):
		factor.x -= __constants.tile_size
	if Input.is_action_just_pressed("ui_left"):
		factor.x += __constants.tile_size
	if Input.is_action_just_pressed("ui_up"):
		factor.y += __constants.tile_size
	if Input.is_action_just_pressed("ui_down"):
		factor.y -= __constants.tile_size
	
	if factor.length():
		emit_signal("pan", factor)
