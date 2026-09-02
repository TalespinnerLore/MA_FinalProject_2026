extends AudioStreamPlayer


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	#get_parent().play_theme(2)
