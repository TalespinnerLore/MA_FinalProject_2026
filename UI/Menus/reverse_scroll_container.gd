extends ScrollContainer

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	ensure_control_visible(get_child(-1))


func _on_scroll_ended() -> void:
	print('end:',get_v_scroll())
	pass # Replace with function body.
