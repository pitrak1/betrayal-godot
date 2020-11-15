extends Node

var current_state = null

func _ready():
	__change_state(get_child(0).name)

func on_change_state(state_name):
	__change_state(state_name)
	
func __change_state(state_name):
	if current_state:
		current_state.hide()
		current_state.disconnect("change_state", self, "on_change_state")
		current_state.exit()
	current_state = find_node(state_name)
	current_state.show()
	current_state.connect("change_state", self, "on_change_state")
	current_state.enter()
	
func _unhandled_input(event):
	current_state.handle_input(event)

func _physics_process(delta):
	current_state.physics_process(delta)

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)
