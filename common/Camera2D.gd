extends Camera2D

func _process(_delta):
	var factor = Vector2()
	if Input.is_action_just_pressed("ui_right"):
		factor.x += 256
	if Input.is_action_just_pressed("ui_left"):
		factor.x -= 256
	if Input.is_action_just_pressed("ui_up"):
		factor.y -= 256
	if Input.is_action_just_pressed("ui_down"):
		factor.y += 256
	
	if factor.length():
		self.position += factor * scale
		
	if Input.is_action_just_pressed("ui_zoom_out"):
		self.zoom -= Vector2(0.2, 0.2)
	if Input.is_action_just_pressed("ui_zoom_in"):
		self.zoom += Vector2(0.2, 0.2)
