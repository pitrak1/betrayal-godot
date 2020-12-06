extends Node

const __actor_scene = preload("res://common/Actor.tscn")

var __id
var __game
var __host
var __actors = []
var __character_entry
var __mine = false

func _ready():
	pass
	
func has_actor(actor):
	return actor in __actors
	
func get_primary_actor():
	return __actors[0]
	
func get_host():
	return __host

func get_character_entry():
	return __character_entry
	
func set_character_entry(entry):
	__character_entry = entry
	
func get_id():
	return __id
	
func get_game():
	return __game
	
func set_game(game):
	__game = game
	
func setup(name, host, character_entry=null, mine=false, id=null):
	self.name = name
	__host = host
	__mine = mine
	__id = id
	__character_entry = character_entry
	
	__actors.append(__actor_scene.instance())
	if character_entry:
		__actors[0].set_character_entry(__character_entry)
		
func create_primary_actor():
	__actors.push_front(__actor_scene.instance())
	if __character_entry:
		__actors[0].set_character_entry(__character_entry)
	
