extends Button


func _on_pressed() -> void:
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = false
		get_parent().visible = false
