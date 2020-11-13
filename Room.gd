extends Sprite

signal select(node)
var key	
var actors = []
var actor_positioning = [
	Vector2(0, 0),
	[Vector2(-100, 0), Vector2(100, 0)],
	[Vector2(-200, 0), Vector2(0, 0), Vector2(200, 0)],
	[Vector2(-100, -100), Vector2(100, -100), Vector2(-100, 100), Vector2(100, 100)]
]

func _ready():
	$SelectedSprite.hide()
	
func add_actor(actor):
	actors.append(actor)
	add_child(actor)
	__reorient_actors()
	
func __reorient_actors():
	var positions = actor_positioning[actors.size()]
	for i in range(actors.size()):
		actors[i].position = positions[i]
		

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
	var scaling_factor = 512 / 2 * global_scale.x
	var within_x_bounds = global_position.x - scaling_factor < position.x and position.x < global_position.x + scaling_factor
	var within_y_bounds = global_position.y - scaling_factor < position.y and position.y < global_position.y + scaling_factor
	return within_x_bounds and within_y_bounds
