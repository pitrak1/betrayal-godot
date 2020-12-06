extends Node

const __turn_manager_script = preload("res://common/TurnManager.gd")
const __room_stack_scene = preload("res://common/RoomStack.tscn")
const __grid_scene = preload("res://common/Grid.tscn")
const __constants_script = preload("res://Constants.gd")
var __players = []
var __waiting_index = 0
var __current_player_index
var __unavailable_characters = []
var __constants
var __room_stack
var __grid

func setup():
	__constants = __constants_script.new()
	
func add_player(player):
	player.set_game(self)
	__players.append(player)
	__waiting_index = __turn_manager_script.new(__players.size())
	__current_player_index = __turn_manager_script.new(__players.size())
	
func confirm_sync(_id, _data):
	if __waiting_index.next():
		return { 
			"response_type": "broadcast", 
			"response": { "status": "success" }, 
			"players": __players 
		}
	else:
		return {
			"response_type": "none"
		}

func get_players(_id, data):
	var parsed_players = []
	for player in __players:
		parsed_players.append({
			"name": player.name,
			"host": player.get_host(),
			"character_entry": player.get_character_entry()
		})
		
	var response_type = "broadcast"
	if data.get("response_type"):
		response_type = data.get("response_type")
		
	return { 
		"response_type": response_type, 
		"response": { 
			"status": "success", 
			"players": parsed_players
		}, 
		"players": __players 
	}
	
func start_game(_id, _data):
	return { 
		"response_type": "broadcast", 
		"response": { "status": "success" }, 
		"players": __players 
	}
		
func get_current_player(_id, _data):
	return { 
		"response_type": "return", 
		"response": { 
			"status": "success", 
			"current_player": __players[__current_player_index.get_index()].name
		}
	}
	
func select_character(id, data):
	var entry = __constants.characters[data["character_index"]]
	
	__unavailable_characters.append(data["character_index"])
	for i in range(__constants.characters.size()):
		if __constants.characters[i]["key"] in entry["related"]:
			__unavailable_characters.append(i)
			
	for p in __players:
		if id == p.get_id():
			p.set_character_entry(__constants.characters[data["character_index"]])
	
	var all_selected = __current_player_index.next()
	if all_selected:
		__room_stack = __room_stack_scene.instance()
		__room_stack.setup()
		
		__grid = __grid_scene.instance()
		__grid.setup(__room_stack)
	
		for player in __players:
			player.create_primary_actor()
			__grid.place_actor(player.get_primary_actor(), Vector2(3, 5))

	return {
		"response_type": "broadcast",
		"response": {
			"status": "success",
			"unavailable_characters": __unavailable_characters,
			"all_selected": all_selected
		},
		"players": __players
	}
	
func move_actor(id, data):
	var start_room = __grid.get_room(data["start_grid_position"])
	var end_room = __grid.get_room(data["end_grid_position"])
	var actor = start_room.get_actor_by_key(data["actor_key"])
	assert(start_room.has_link(end_room))
	for p in __players:
		if id == p.get_id():
			assert(p.has_actor(actor))
	__grid.remove_actor(actor, data["start_grid_position"])
	__grid.place_actor(actor, data["end_grid_position"])
	return { 
		"response_type": "broadcast",
		"response": {
			"actor_key": data["actor_key"],
			"start_grid_position": data["start_grid_position"],
			"end_grid_position": data["end_grid_position"],
			"status": "success"
		},
		"players": __players
	}

