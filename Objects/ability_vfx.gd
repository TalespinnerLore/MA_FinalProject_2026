extends Node2D

var life_span:= 0.25


func timeout():
	await get_tree().create_timer(life_span).timeout
	queue_free()

func _ready() -> void:
	print(Global.pos_to_grid(self.global_position), "VFX GRID LOC")
	timeout()
	pass
