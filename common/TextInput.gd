extends Control

var min_length
var max_length
	
func validate():
	var text = $LineEdit.text
	var regex = RegEx.new()
	regex.compile("\\W")
	
	if text.length() < self.min_length:
		set_validation_label("Must be " + str(self.min_length) + " characters or greater")
		return false
	elif text.length() > self.max_length:
		set_validation_label("Must be " + str(self.max_length) + " characters or less")
		return false
	elif regex.search(text):
		set_validation_label("Only alphanumeric allowed")
		return false
	else:
		hide_validation_label()
		return true

func setup(label, min_length, max_length):
	$Label.text = label
	self.min_length = min_length
	self.max_length = max_length

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


