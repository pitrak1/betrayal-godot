extends Node

var __nonalphanumeric_regex

func player_name_validator(value, players={}):
	var min_length = 5
	var max_length = 15
	
	if not __nonalphanumeric_regex:
		__nonalphanumeric_regex = RegEx.new()
		__nonalphanumeric_regex.compile("\\W")
	
	if value.length() < min_length:
		return "shorter_than_" + str(min_length) + "_characters"
	elif value.length() > max_length:
		return "longer_than_" + str(max_length) + "_characters"
	elif __nonalphanumeric_regex.search(value):
		return "nonalphanumeric_found"
	elif value in players.keys():
		return "player_name_taken"
	else:
		return null
		
func game_name_validator(value, create, games={}):
	var min_length = 5
	var max_length = 15
	
	if not __nonalphanumeric_regex:
		__nonalphanumeric_regex = RegEx.new()
		__nonalphanumeric_regex.compile("\\W")
	
	if value.length() < min_length:
		return "shorter_than_" + str(min_length) + "_characters"
	elif value.length() > max_length:
		return "longer_than_" + str(max_length) + "_characters"
	elif __nonalphanumeric_regex.search(value):
		return "nonalphanumeric_found"
	elif create and value in games.keys():
		return "game_name_taken"
	elif not create and not value in games.keys():
		return "game_not_found"
	else:
		return null
