extends Node

const __room_stack = preload("res://common/RoomStack.tscn")
const __grid_scene = preload("res://common/Grid.tscn")
const __player_scene = preload("res://common/Player.tscn")
const __actor_scene = preload("res://common/Actor.tscn")


func setup(global_context, players):
	var room_stack = __room_stack.instance()
	room_stack.setup()
	
	var grid = __grid_scene.instance()
	grid.setup(room_stack)
	
	var player_nodes = __setup_players(global_context, players, grid)
	
	global_context.grid_info["grid"] = grid
	global_context.player_info["players"] = player_nodes
	global_context.grid_info["room_stack"] = room_stack
	
func __setup_players(global_context, players, grid):
	var player_nodes = []
	for player_info in players:
		var player = __player_scene.instance()
		player.setup(
			player_info["name"],
			player_info["host"],
			player_info["character_entry"],
			player_info["name"] == global_context.player_info["player_name"]
		)
		grid.place_actor(player.get_primary_actor(), Vector2(3, 5))
	return player_nodes
