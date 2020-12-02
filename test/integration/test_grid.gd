extends "res://addons/gut/test.gd"

class TestSetup:
	extends "res://addons/gut/test.gd"

	const __constants_script = preload("res://Constants.gd")
	const __grid_scene = preload("res://common/Grid.tscn")
	const __room_stack_scene = preload("res://common/RoomStack.tscn")
	const __empty_room_script = preload("res://common/EmptyRoom.gd")

	var grid
	var room_stack
	var constants

	func before_all():
		constants = __constants_script.new()

	func before_each():
		room_stack = __room_stack_scene.instance()
		room_stack.setup()
		grid = __grid_scene.instance()
		add_child(grid)
		grid.setup(room_stack)
		watch_signals(grid)

	func after_each():
		remove_child(grid)

	func test_places_starting_rooms():
		for starting_room in constants.starting_rooms:
			var room
			for r in constants.rooms:
				if r.key == starting_room["key"]:
					room = r
			assert_eq(grid.get_room(starting_room["position"]).name, room["name"])

	func test_places_empty_rooms_by_default():
		assert_true(grid.get_room(Vector2(4, 4)) is __empty_room_script)
		
class TestPlaceRoom:
	extends "res://addons/gut/test.gd"
	
	const __constants_script = preload("res://Constants.gd")
	const __grid_scene = preload("res://common/Grid.tscn")
	const __room_stack_scene = preload("res://common/RoomStack.tscn")
	
	var grid
	var room_stack
	var constants
	
	func before_all():
		constants = __constants_script.new()

	func before_each():
		room_stack = __room_stack_scene.instance()
		room_stack.setup()
		grid = __grid_scene.instance()
		add_child(grid)
		grid.setup(room_stack)
		watch_signals(grid)
		
	func after_each():
		remove_child(grid)

	func test_allows_rooms_to_be_placed():
		var room = room_stack.get_by_key("cave")
		grid.place_room(room, Vector2(5, 5))
		assert_eq(grid.get_room(Vector2(5, 5)).name, room.name)

	func test_allows_rooms_to_be_replaced():
		var room = room_stack.get_by_key("cave")
		grid.place_room(room, Vector2(3, 3))
		assert_eq(grid.get_room(Vector2(3, 3)).name, room.name)

	func test_adds_room_as_child():
		var room = room_stack.get_by_key("cave")
		grid.place_room(room, Vector2(5, 5))
		assert_true(room in grid.get_children())

	func test_sets_room_position():
		var room = room_stack.get_by_key("cave")
		grid.place_room(room, Vector2(4, 5))
		assert_eq(room.position, Vector2(4 * constants.tile_size, 5 * constants.tile_size))

	func test_sets_grid_position():
		var room = room_stack.get_by_key("cave")
		grid.place_room(room, Vector2(4, 5))
		assert_eq(room.grid_position, Vector2(4, 5))

	func test_sets_rotation():
		var room = room_stack.get_by_key("cave")
		grid.place_room(room, Vector2(4, 5), 3 * PI / 2)
		assert_almost_eq(room.get_node("RoomSprite").rotation, 3 * PI / 2, PI / 8)

	func test_rotates_doors():
		var room = room_stack.get_by_key("underground_lake")
		grid.place_room(room, Vector2(4, 5), PI / 2)
		assert_false(room.has_door(constants.UP))
		assert_true(room.has_door(constants.RIGHT))
		assert_true(room.has_door(constants.DOWN))
		assert_false(room.has_door(constants.LEFT))

	func test_connects_select_signal_to_parent():
		var room = room_stack.get_by_key("underground_lake")
		grid.place_room(room, Vector2(4, 5))
		assert_connected(room, self, "select", "select_handler")

	func test_connects_activate_signal_to_parent():
		var room = room_stack.get_by_key("underground_lake")
		grid.place_room(room, Vector2(4, 5))
		assert_connected(room, self, "activate", "activate_handler")

	func test_places_links_to_adjacent_tiles_if_appropriate_doors():
		assert_true(grid.get_room(Vector2(3, 3)).has_link(grid.get_room(Vector2(3, 4))))
		assert_true(grid.get_room(Vector2(3, 4)).has_link(grid.get_room(Vector2(3, 3))))

	func test_places_links_to_empty_tiles_if_appropriate_doors():
		assert_true(grid.get_room(Vector2(3, 5)).has_link(grid.get_room(Vector2(4, 5))))

class TestRemoveRoom:
	extends "res://addons/gut/test.gd"

	const __constants_script = preload("res://Constants.gd")
	const __grid_scene = preload("res://common/Grid.tscn")
	const __room_stack_scene = preload("res://common/RoomStack.tscn")
	const __empty_room_script = preload("res://common/EmptyRoom.gd")

	var grid
	var room_stack
	var constants
	var room

	func before_all():
		constants = __constants_script.new()

	func before_each():
		room_stack = __room_stack_scene.instance()
		room_stack.setup()
		grid = __grid_scene.instance()
		add_child(grid)
		grid.setup(room_stack)
		room = room_stack.get_by_key("underground_lake")
		grid.place_room(room, Vector2(4, 4), PI/2)
		watch_signals(grid)

	func after_each():
		remove_child(grid)

	func test_allows_rooms_to_be_removed_and_replaced_with_empty_room():
		grid.remove_room(Vector2(4, 4))
		assert_true(grid.get_room(Vector2(4, 4)) is __empty_room_script)

	func test_removes_links_to_adjacent_tiles():
		var room = grid.remove_room(Vector2(3, 3))
		assert_false(grid.get_room(Vector2(3, 4)).has_link(room))
		assert_false(room.has_link(grid.get_room(Vector2(3, 4))))

	func test_removes_room_as_child():
		var room = grid.remove_room(Vector2(4, 4))
		assert_false(room in grid.get_children())
		
	func test_resets_grid_position():
		var room = grid.remove_room(Vector2(4, 4))
		assert_eq(room.grid_position, null)
	
	func test_resets_rotation():
		var room = grid.remove_room(Vector2(4, 4))
		assert_eq(room.rotation, 0)
		
	func test_disconnects_select_signal_from_parent():
		var room = grid.remove_room(Vector2(4, 4))
		assert_not_connected(room, self, "select", "select_handler")
		
	func test_disconnects_activate_signal_from_parent():
		var room = grid.remove_room(Vector2(4, 4))
		assert_not_connected(room, self, "activate", "activate_handler")

class TestPlaceActor:
	extends "res://addons/gut/test.gd"
	
	const __constants_script = preload("res://Constants.gd")
	const __grid_scene = preload("res://common/Grid.tscn")
	const __room_stack_scene = preload("res://common/RoomStack.tscn")
	const __actor_scene = preload("res://common/Actor.tscn")
	
	var grid
	var room_stack
	var constants
	var actor
	
	func before_all():
		constants = __constants_script.new()

	func before_each():
		room_stack = __room_stack_scene.instance()
		room_stack.setup()
		grid = __grid_scene.instance()
		add_child(grid)
		grid.setup(room_stack)
		actor = __actor_scene.instance()
		watch_signals(grid)
		grid.place_actor(actor, Vector2(3, 4))
		
	func after_each():
		remove_child(grid)
		
	func test_adds_actor_to_room():
		assert_true(grid.get_room(Vector2(3, 4)).has_actor(actor))
		
	func test_connects_select_signal_to_parent():
		assert_connected(actor, self, "select", "select_handler")

	func test_connects_activate_signal_to_parent():
		assert_connected(actor, self, "activate", "activate_handler")
		

class TestRemoveActor:
	extends "res://addons/gut/test.gd"
	
	const __constants_script = preload("res://Constants.gd")
	const __grid_scene = preload("res://common/Grid.tscn")
	const __room_stack_scene = preload("res://common/RoomStack.tscn")
	const __actor_scene = preload("res://common/Actor.tscn")
	
	var grid
	var room_stack
	var constants
	var actor
	
	func before_all():
		constants = __constants_script.new()

	func before_each():
		room_stack = __room_stack_scene.instance()
		room_stack.setup()
		grid = __grid_scene.instance()
		add_child(grid)
		grid.setup(room_stack)
		actor = __actor_scene.instance()
		grid.place_actor(actor, Vector2(3, 4))
		watch_signals(grid)
		grid.remove_actor(actor, Vector2(3, 4))
		
	func after_each():
		remove_child(grid)
		
	func test_removes_actor_from_room():
		assert_false(grid.get_room(Vector2(3, 4)).has_actor(actor))
		
	func test_disconnects_select_signal_from_parent():
		assert_not_connected(actor, self, "select", "select_handler")

	func test_disconnects_activate_signal_from_parent():
		assert_not_connected(actor, self, "activate", "activate_handler")
