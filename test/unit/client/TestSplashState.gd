extends "res://addons/gut/test.gd"

var splash_state_scene = preload("res://client/splash/SplashState.tscn")
var state_machine_double
var state

func before_each():
	state_machine_double = partial_double("res://StateMachine.gd").new()
	get_tree().get_root().remove_child(get_node("/root/StateMachine"))
	state_machine_double.name = "StateMachine"
	get_tree().get_root().add_child(state_machine_double)
	
	state = splash_state_scene.instance()
	add_child(state)
	
func after_each():
	remove_child(state)
	state.queue_free()

func test_connects_start_button_pressed():
	assert_connected(state.get_node("UICanvasLayer/MenuPanel/StartButton"), state, "pressed")
	
func test_transitions_to_main_menu_when_start_button_pressed():
	stub(state_machine_double, 'set_state').to_do_nothing()
	state.on_StartButton_pressed()
	assert_eq(get_call_parameters(state_machine_double, 'set_state', 0), ["res://client/main_menu/MainMenuState.tscn"])
