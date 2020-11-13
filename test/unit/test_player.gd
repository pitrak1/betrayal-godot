extends "res://addons/gut/test.gd"
	
var Player = preload("res://Player.tscn")
var player

func before_each():
	player = Player.instance()
	add_child(player)
	
func after_each():
	remove_child(player)

func test_starts_not_selected():
	assert_false(player.get_node("SelectedSprite").visible)

func test_selected_if_select_handler_given_own_name():
	gut.p(player.name)
	player.select_handler(player.name)
	assert_true(player.get_node("SelectedSprite").visible)

func test_unselected_if_select_handler_not_given_self():
	player.select_handler(player.name)
	player.select_handler("Other Name")
	assert_false(player.get_node("SelectedSprite").visible)

