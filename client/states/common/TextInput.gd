extends Control

var __min_length
var __max_length
	
func validate():
	var text = $LineEdit.text
	var regex = RegEx.new()
	regex.compile("\\W")
	
	if text.length() < __min_length:
		set_validation_label("Must be " + str(__min_length) + " characters or greater")
		return false
	elif text.length() > __max_length:
		set_validation_label("Must be " + str(__max_length) + " characters or less")
		return false
	elif regex.search(text):
		set_validation_label("Only alphanumeric allowed")
		return false
	else:
		hide_validation_label()
		return true

func setup(label, min_length, max_length):
	$Label.text = label
	__min_length = min_length
	__max_length = max_length

func hide_validation_label():
	$ValidationLabel.hide()
	
func show_validation_label():
	$ValidationLabel.show()
	
func set_validation_label(text):
	show_validation_label()
	$ValidationLabel.text = text
	
func get_input_text():
	return $LineEdit.text
	
func set_input_text(text):
	$LineEdit.text = text


