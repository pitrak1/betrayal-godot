extends Control

func set_label(text):
	$Label.text = text

func hide_validation_label():
	$ValidationLabel.hide()
	
func show_validation_label():
	$ValidationLabel.show()
	
func set_validation_label(text):
	show_validation_label()
	$ValidationLabel.text = text
	
func get_input_text():
	return $LineEdit.text
