extends Node2D

signal select(node)
var key

var might_values = []
var might_index = 0
var speed_values = []
var speed_index = 0
var knowledge_values = []
var knowledge_index = 0
var sanity_values = []
var sanity_index = 0

func _ready():
	$SelectedSprite.hide()
	
func set_character_entry(entry):
	$ActorSprite.texture = load("res://assets/" + entry["portrait_asset"])
	might_values = entry["might"]
	might_index = entry["might_index"]
	speed_values = entry["speed"]
	speed_index = entry["speed_index"]
	knowledge_values = entry["knowledge"]
	knowledge_index = entry["knowledge_index"]
	sanity_values = entry["sanity"]
	sanity_index = entry["sanity_index"]

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
	var scaling_factor = $Constants.actor_size / 2 * global_scale.x
	return global_position.distance_to(position) < scaling_factor
