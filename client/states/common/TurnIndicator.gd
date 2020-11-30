extends Label

var __player_name

func setup(player_name):
	__player_name = player_name
	
func set_player(player_name):
	if player_name == __player_name:
		text = "It is your turn!"
	else:
		text = player_name + "'s turn!"
