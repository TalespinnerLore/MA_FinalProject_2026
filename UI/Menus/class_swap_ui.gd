extends Control

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused

func _player_interaction():
	pause_level()
	self.visible = true



func _on_button_pressed() -> void:
	SaveLoad.change_class('Civilian')
	self.visible = false
	pause_level()
	pass # Replace with function body.


func _on_button_pressed1() -> void:
	SaveLoad.change_class('Vanguard')
	self.visible = false
	pause_level()
	pass # Replace with function body.


func _on_button_pressed2() -> void:
	SaveLoad.change_class('Warrior')
	self.visible = false
	pause_level()
	pass # Replace with function body.


func _on_button_pressed3() -> void:
	SaveLoad.change_class('Rogue')
	self.visible = false
	pause_level()
	pass # Replace with function body.


func _on_button_pressed4() -> void:
	SaveLoad.change_class('Mage')
	self.visible = false
	pause_level()
	pass # Replace with function body.


func _on_button_pressed5() -> void:
	SaveLoad.change_class('Healer')
	self.visible = false
	pause_level()
	pass # Replace with function body.


func _on_button_pressed6() -> void:
	SaveLoad.change_class('Jester')
	self.visible = false
	pause_level()
	pass # Replace with function body.
