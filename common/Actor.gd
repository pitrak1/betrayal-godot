extends Node2D

signal select(node)
signal activate(node)

const __constants_script = preload("res://Constants.gd")

var key
var __might_values = []
var __might_index = 0
var __speed_values = []
var __speed_index = 0
var __knowledge_values = []
var __knowledge_index = 0
var __sanity_values = []
var __sanity_index = 0
var _constants
var grid_position

func _ready():
	$SelectedSprite.hide()
	_constants = __constants_script.new()
	
func set_character_entry(entry):
	$ActorSprite.texture = load("res://assets/" + entry["portrait_asset"])
	__might_values = entry["might"]
	__might_index = entry["might_index"]
	__speed_values = entry["speed"]
	__speed_index = entry["speed_index"]
	__knowledge_values = entry["knowledge"]
	__knowledge_index = entry["knowledge_index"]
	__sanity_values = entry["sanity"]
	__sanity_index = entry["sanity_index"]

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		if is_in_bounds(event.global_position):
			emit_signal("select", self)
			
func select_handler(node):
	if node == self:
		$SelectedSprite.show()
	else:
		$SelectedSprite.hide()

func is_in_bounds(position):
	var scaling_factor = _constants.actor_size / 2 * global_scale.x
	return global_position.distance_to(position) < scaling_factor
