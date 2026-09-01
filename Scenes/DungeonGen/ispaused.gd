extends Control
@onready var unit:Unit_Instance = get_parent().get_parent()

func _process(delta: float) -> void:
	if unit.Team == unit.Teams.PLAYER:
		if get_tree().paused == true:
			self.visible = true
			$Label.text = 'PAUSED'
			#$Button.visible = true
			#$Label.text.COLOR
		else:
			$Label.text = 'RUNNING'
			$Button.visible = false
	else:
		queue_free()



func _on_timer_timeout() -> void:
	if get_tree().paused == true:
		get_tree().paused = false
