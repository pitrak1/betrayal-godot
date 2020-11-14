extends Node

export var UP = 0
export var RIGHT = 1
export var DOWN = 2
export var LEFT = 3

export var grid_dimensions = Vector2(10, 10)
export var tile_size = 512
export var actor_size = 150

export var rooms = [
	{
		"key": "grand_staircase",
		"name": "Grand Staircase",
		"index": Vector2(0, 8),
		"doors": [false, true, false, false]
	},
	{
		"key": "foyer",
		"name": "Foyer",
		"index": Vector2(1, 8),
		"doors": [true, true, true, true]
	},
	{
		"key": "entrance_hall",
		"name": "Entrance Hall",
		"index": Vector2(2, 8),
		"doors": [true, false, true, true]
	},
	{
		"key": "dungeon",
		"name": "Dungeon",
		"index": Vector2(0, 7),
		"doors": [true, false, true, false]
	},
	{
		"key": "furnace_room",
		"name": "Furnace Room",
		"index": Vector2(1, 7),
		"doors": [true, false, true, true]
	},
	{
		"key": "larder",
		"name": "Larder",
		"index": Vector2(2, 7),
		"doors": [true, false, true, false]
	},
	{
		"key": "pentagram_chamber",
		"name": "Pentagram Chamber",
		"index": Vector2(3, 7),
		"doors": [false, true, false, false]
	},
	{
		"key": "stairs_from_basement",
		"name": "Stairs From Basement",
		"index": Vector2(4, 7),
		"doors": [true, false, true, false]
	},
	{
		"key": "storm_cellar",
		"name": "Storm Cellar",
		"index": Vector2(5, 7),
		"doors": [false, true, true, false]
	},
	{
		"key": "underground_lake",
		"name": "Underground Lake",
		"index": Vector2(6, 7),
		"doors": [true, true, false, false]
	},
	{
		"key": "wine_cellar",
		"name": "Wine Cellar",
		"index": Vector2(7, 7),
		"doors": [true, false, true, false]
	},
	{
		"key": "arsenal",
		"name": "Arsenal",
		"index": Vector2(0, 6),
		"doors": [true, false, true, false]
	},
	{
		"key": "kitchen",
		"name": "Kitchen",
		"index": Vector2(1, 6),
		"doors": [true, true, false, false]
	},
	{
		"key": "laundry",
		"name": "Laundry",
		"index": Vector2(2, 6),
		"doors": [false, false, true, true]
	},
	{
		"key": "menagerie",
		"name": "Menagerie",
		"index": Vector2(3, 6),
		"doors": [false, true, false, true]
	},
	{
		"key": "catacombs",
		"name": "Catacombs",
		"index": Vector2(4, 6),
		"doors": [true, false, true, false]
	},
	{
		"key": "cave",
		"name": "Cave",
		"index": Vector2(5, 6),
		"doors": [true, true, true, true]
	},
	{
		"key": "chasm",
		"name": "Chasm",
		"index": Vector2(6, 6),
		"doors": [false, true, false, true]
	},
	{
		"key": "crypt",
		"name": "Crypt",
		"index": Vector2(7, 6),
		"doors": [true, false, false, false]
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
