extends "res://client/State.gd"

var __sprite1 = load("res://assets/zoe_ingstrom.png")
var __sprite2 = load("res://assets/missy_dubourde.png")
var __current_sprite = 1

var __texture1 = load("res://assets/ox_bellows.png")
var __texture2 = load("res://assets/darrin_williams.png")
var __current_texture = 1

func _ready():
	$UICanvasLayer/GoToGameButton.connect("pressed", self, "on_GoToGameButton_pressed")
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		
		# event.global_position gets the offset from the top left of the viewport, so subtracting the size of the viewport and applying the zoom factor and camera position works
		var adjusted_position = event.global_position * $Camera2D.zoom - get_viewport().size * $Camera2D.zoom / 2 + $Camera2D.position
		if __within_bounds(adjusted_position, $Sprite.position, 150, 150):
			if __current_sprite == 1:
				$Sprite.texture = __sprite2
				__current_sprite = 2
			else:
				$Sprite.texture = __sprite1
				__current_sprite = 1
		
		# Because our CanvasLayer is at 0,0 and overlaps our camera entirely, both positions start from the top left of the viewport
		# The 75, 75 is just because a textureRect's position is measured from the upper left apparently
		if __within_bounds(event.global_position, $UICanvasLayer/TextureRect.rect_position + Vector2(75, 75), 150, 150):
			if __current_texture == 1:
				$UICanvasLayer/TextureRect.texture = __texture2
				__current_texture = 2
			else:
				$UICanvasLayer/TextureRect.texture = __texture1
				__current_texture = 1
			
func on_GoToGameButton_pressed():
	_global_context.player_info["host"] = true
	_global_context.player_info["player_name"] = "player " + str(randi() % 500)
	_global_context.player_info["game_name"] = "lobby " + str(randi() % 500)
	send_network_command("register_player_and_create_game", {
		"player_name": _global_context.player_info["player_name"], 
		"game_name": _global_context.player_info["game_name"]
	})
	
func register_player_and_create_game_response(_data):
	send_network_command("select_character", { "character_index": randi() % _constants.characters.size() })
	
func select_character_response(_response):
	_state_machine.set_state("res://client/game_turn/GameTurnState.tscn")
		
func __within_bounds(point, center, width, height):
	var in_x = center.x - width/2 < point.x and point.x < center.x + width/2
	var in_y = center.y - height/2 < point.y and point.y < center.y + height/2
	return in_x and in_y
	
