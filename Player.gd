extends Sprite

signal select(node)
var key

func _ready():
	$SelectedSprite.hide()

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
