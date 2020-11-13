extends Node

export var grid_dimensions = Vector2(10, 10)
export var tile_size = 512
export var actor_size = 150

export var rooms = [
	{
		"key": "grand_staircase",
		"name": "Grand Staircase",
		"index": Vector2(0, 8)
	},
	{
		"key": "foyer",
		"name": "Foyer",
		"index": Vector2(1, 8)
	},
	{
		"key": "entrance_hall",
		"name": "Entrance Hall",
		"index": Vector2(2, 8)
	},
	{
		"key": "dungeon",
		"name": "Dungeon",
		"index": Vector2(0, 7)
	},
	{
		"key": "furnace_room",
		"name": "Furnace Room",
		"index": Vector2(1, 7)
	},
	{
		"key": "larder",
		"name": "Larder",
		"index": Vector2(2, 7)
	}
]

export var starting_rooms = [
	{
		"key": "grand_staircase",
		"position": Vector2(0, -2),
		"rotation": PI/2
	},
	{
		"key": "foyer",
		"position": Vector2(0, -1),
		"rotation": PI/2
	},
	{
		"key": "entrance_hall",
		"position": Vector2(0, 0),
		"rotation": PI/2
	}
]
