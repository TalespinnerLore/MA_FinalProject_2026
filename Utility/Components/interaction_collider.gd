extends Area2D

var can_press_E := false

func _on_body_entered(body: Node2D) -> void:
	print(body,' ',)
	if body is Unit_Instance or body is Unit_Instance_NonCombat:
		$Label.visible = true
		can_press_E = true

func _process(delta: float) -> void:
	if can_press_E and Input.is_action_just_pressed('Interact'):
		var parent  = get_parent()
		if parent.has_method('interaction'):
			parent.interaction()

func _on_body_exited(body: Node2D) -> void:
	if body is Unit_Instance or body is Unit_Instance_NonCombat:
		$Label.visible = false
		can_press_E = false
