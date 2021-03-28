extends Control

var __attribute_index = 0

func set_attribute_name(name):
	$NameLabel.text = name
	
func set_attribute_values(values):
	var text = ""
	for value in values:
		text += str(value) + " "
	text = text.substr(0, text.length() - 1)
	$ValueLabel.text = text
	
func set_attribute_index(index):
	var difference = index - __attribute_index
	__attribute_index = index
	$HighlightSprite.position.x += difference * rect_scale.x * 18

