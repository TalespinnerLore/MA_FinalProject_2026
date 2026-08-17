extends NinePatchRect
func _on_mouse_entered() -> void:
	#print('mouse in')
	self.texture = load("res://Art/UI_Art/Frames/ui_bg_blueoutline.png")


func _on_mouse_exited() -> void:
	self.texture = load("res://Art/UI_Art/Frames/ui_bg_yellowoutline.png")
