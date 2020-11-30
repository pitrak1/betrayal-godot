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

export var characters = [
	{
		'display_name': 'Heather Granville',
		'key': 'heather_granville',
		'portrait_asset': 'heather_granville.png',
		'speed': [0, 3, 3, 4, 5, 6, 6, 7, 8],
		'speed_index': 3,
		'might': [0, 3, 3, 3, 4, 5, 6, 7, 8],
		'might_index': 3,
		'sanity': [0, 3, 3, 3, 4, 5, 6, 6, 6],
		'sanity_index': 3,
		'knowledge': [0, 2, 3, 3, 4, 5, 6, 7, 8],
		'knowledge_index': 5,
		'related': ['jenny_leclerc'],
		'status': ''
	},
	{
		'display_name': 'Jenny LeClerc',
		'key': 'jenny_leclerc',
		'portrait_asset': 'jenny_leclerc.png',
		'speed': [0, 2, 3, 4, 4, 4, 5, 6, 8],
		'speed_index': 4,
		'might': [0, 3, 4, 4, 4, 4, 5, 6, 8],
		'might_index': 3,
		'sanity': [0, 1, 1, 2, 4, 4, 4, 5, 6],
		'sanity_index': 5,
		'knowledge': [0, 2, 3, 3, 4, 4, 5, 6, 8],
		'knowledge_index': 3,
		'related': ['heather_granville'],
		'status': ''
	},
	{
		'display_name': 'Madame Zostra',
		'key': 'madame_zostra',
		'portrait_asset': 'madame_zostra.png',
		'speed': [0, 2, 3, 3, 5, 5, 6, 6, 7],
		'speed_index': 3,
		'might': [0, 2, 3, 3, 4, 5, 5, 5, 6],
		'might_index': 4,
		'sanity': [0, 4, 4, 4, 5, 6, 7, 8, 8],
		'sanity_index': 3,
		'knowledge': [0, 1, 3, 4, 4, 4, 5, 6, 6],
		'knowledge_index': 4,
		'related': ['vivian_lopez'],
		'status': ''
	},
	{
		'display_name': 'Vivian Lopez',
		'key': 'vivian_lopez',
		'portrait_asset': 'vivian_lopez.png',
		'speed': [0, 3, 4, 4, 4, 4, 6, 7, 8],
		'speed_index': 4,
		'might': [0, 2, 2, 2, 4, 4, 5, 6, 6],
		'might_index': 3,
		'sanity': [0, 4, 4, 4, 5, 6, 7, 8, 8],
		'sanity_index': 3,
		'knowledge': [0, 4, 5, 5, 5, 5, 6, 6, 7],
		'knowledge_index': 4,
		'related': ['madame_zostra'],
		'status': ''
	},
	{
		'display_name': 'Brandon Jaspers',
		'key': 'brandon_jaspers',
		'portrait_asset': 'brandon_jaspers.png',
		'speed': [0, 3, 4, 4, 4, 5, 6, 7, 8],
		'speed_index': 3,
		'might': [0, 2, 3, 3, 4, 5, 6, 6, 7],
		'might_index': 4,
		'sanity': [0, 3, 3, 3, 4, 5, 6, 7, 8],
		'sanity_index': 4,
		'knowledge': [0, 1, 3, 3, 5, 5, 6, 6, 7],
		'knowledge_index': 3,
		'related': ['peter_akimoto'],
		'status': ''
	},
	{
		'display_name': 'Peter Akimoto',
		'key': 'peter_akimoto',
		'portrait_asset': 'peter_akimoto.png',
		'speed': [0, 3, 3, 3, 4, 6, 6, 7, 7],
		'speed_index': 4,
		'might': [0, 2, 3, 3, 4, 5, 5, 6, 8],
		'might_index': 3,
		'sanity': [0, 3, 4, 4, 4, 5, 6, 6, 7],
		'sanity_index': 4,
		'knowledge': [0, 3, 4, 4, 5, 6, 7, 7, 8],
		'knowledge_index': 3,
		'related': ['brandon_jaspers'],
		'status': ''
	},
	{
		'display_name': 'Darrin Williams',
		'key': 'darrin_williams',
		'portrait_asset': 'darrin_williams.png',
		'speed': [0, 4, 4, 4, 5, 6, 7, 7, 8],
		'speed_index': 5,
		'might': [0, 2, 3, 3, 4, 5, 6, 6, 7],
		'might_index': 3,
		'sanity': [0, 1, 2, 3, 4, 5, 5, 5, 7],
		'sanity_index': 3,
		'knowledge': [0, 2, 3, 3, 4, 5, 5, 5, 7],
		'knowledge_index': 3,
		'related': ['ox_bellows'],
		'status': ''
	},
	{
		'display_name': 'Ox Bellows',
		'key': 'ox_bellows',
		'portrait_asset': 'ox_bellows.png',
		'speed': [0, 2, 2, 2, 3, 4, 5, 5, 6],
		'speed_index': 5,
		'might': [0, 4, 5, 5, 6, 6, 7, 8, 8],
		'might_index': 3,
		'sanity': [0, 2, 2, 3, 4, 5, 5, 6, 7],
		'sanity_index': 3,
		'knowledge': [0, 2, 2, 3, 3, 5, 5, 6, 6],
		'knowledge_index': 3,
		'related': ['darrin_williams'],
		'status': ''
	},
	{
		'display_name': 'Zoe Ingstrom',
		'key': 'zoe_ingstrom',
		'portrait_asset': 'zoe_ingstrom.png',
		'speed': [0, 4, 4, 4, 4, 5, 6, 8, 8],
		'speed_index': 4,
		'might': [0, 2, 2, 3, 3, 4, 4, 6, 7],
		'might_index': 4,
		'sanity': [0, 3, 4, 5, 5, 6, 6, 7, 8],
		'sanity_index': 3,
		'knowledge': [0, 1, 2, 3, 4, 4, 5, 5, 5],
		'knowledge_index': 3,
		'related': ['missy_dubourde'],
		'status': ''
	},
	{
		'display_name': 'Missy Dubourde',
		'key': 'missy_dubourde',
		'portrait_asset': 'missy_dubourde.png',
		'speed': [0, 3, 4, 5, 6, 6, 6, 7, 7],
		'speed_index': 3,
		'might': [0, 2, 3, 3, 3, 4, 5, 6, 7],
		'might_index': 4,
		'sanity': [0, 1, 2, 3, 4, 5, 5, 6, 7],
		'sanity_index': 3,
		'knowledge': [0, 2, 3, 4, 4, 5, 6, 6, 6],
		'knowledge_index': 4,
		'related': ['zoe_ingstrom'],
		'status': ''
	},
	{
		'display_name': 'Professor Longfellow',
		'key': 'professor_longfellow',
		'portrait_asset': 'professor_longfellow.png',
		'speed': [0, 2, 2, 4, 4, 5, 5, 6, 6],
		'speed_index': 4,
		'might': [0, 1, 2, 3, 4, 5, 5, 6, 6],
		'might_index': 3,
		'sanity': [0, 1, 3, 3, 4, 5, 5, 6, 7],
		'sanity_index': 3,
		'knowledge': [0, 4, 5, 5, 5, 5, 6, 7, 8],
		'knowledge_index': 5,
		'related': ['father_rhinehardt'],
		'status': ''
	},
	{
		'display_name': 'Father Rhinehardt',
		'key': 'father_rhinehardt',
		'portrait_asset': 'father_rhinehardt.png',
		'speed': [0, 2, 3, 3, 4, 5, 6, 7, 7],
		'speed_index': 3,
		'might': [0, 1, 2, 2, 4, 4, 5, 5, 7],
		'might_index': 3,
		'sanity': [0, 3, 4, 5, 5, 6, 7, 7, 8],
		'sanity_index': 5,
		'knowledge': [0, 1, 3, 3, 4, 5, 6, 6, 8],
		'knowledge_index': 4,
		'related': ['professor_longfellow'],
		'status': ''
	}
]

export var ip_address = "localhost"
export var port = 8910
