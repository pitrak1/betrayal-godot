extends CanvasItem

signal log_string(string)
# warning-ignore:unused_signal
signal change_state(state_name, custom_data)
# warning-ignore:unused_signal
signal send_network_command(command_name, data)

const __constants_script = preload("res://Constants.gd")

var _custom_data
var _host
var _player_name
var _game_name
var _constants
var _grid

func enter(custom_data):
	emit_signal("log_string", "Entering " + self.name + "...")
	_custom_data = custom_data
	if "host" in custom_data.keys():
		_host = custom_data["host"]
	if "player_name" in custom_data.keys():
		_player_name = custom_data["player_name"]
	if "game_name" in custom_data.keys():
		_game_name = custom_data["game_name"]
	if "grid" in custom_data.keys():
		_grid = custom_data["grid"]
	_constants = __constants_script.new()

func exit():
	pass

func handle_input(_event):
	pass

func physics_process(_delta):
	pass

func _on_animation_finished(_anim_name):
	pass
