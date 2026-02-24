extends Node2D

var life_span:= 0.25


func timeout():
	await get_tree().create_timer(life_span).timeout
	queue_free()

func _ready() -> void:
	print(Global.grid_to_pos(Vector2i(0,0),self.global_position)[0], "VFX POS")
	timeout()
	pass
