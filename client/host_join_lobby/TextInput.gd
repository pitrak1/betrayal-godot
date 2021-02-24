extends Control

func set_label(label):
	$Label.text = label

func hide_validation_label():
	$ValidationLabel.hide()
	
func show_validation_label():
	$ValidationLabel.show()
	
func set_validation_label(text):
	if text == null:
		hide_validation_label()
	else:
		show_validation_label()
		$ValidationLabel.text = text
	
func get_input_text():
	return $LineEdit.text
	
func set_input_text(text):
	$LineEdit.text = text


