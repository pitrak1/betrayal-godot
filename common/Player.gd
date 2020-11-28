extends Node

var actor_scene = preload("res://common/Actor.tscn")

var id
var game
var host
var actors = []
var character_entry
var mine = false

func _ready():
	pass
	
func setup(name, host, mine, character_entry):
	self.name = name
	self.host = host
	self.mine = mine
	self.character_entry = character_entry
	
	self.actors.append(actor_scene.instance())
	self.actors[0].set_character_entry(self.character_entry)
	
