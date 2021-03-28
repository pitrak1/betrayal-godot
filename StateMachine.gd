extends Node

# https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html
var current_scene = null

func set_state(path):
	call_deferred("_deferred_set_state", path)
	
func _deferred_set_state(path):
	if current_scene != null:
		current_scene.free()
	var scene = ResourceLoader.load(path)
	current_scene = scene.instance()
	var global_context = get_node("/root/GlobalContext")
	global_context.game_info["current_state"] = current_scene
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
