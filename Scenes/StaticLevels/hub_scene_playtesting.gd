extends Node2D
func _ready() -> void:
	if get_tree().paused == true:
		get_tree().paused = false
