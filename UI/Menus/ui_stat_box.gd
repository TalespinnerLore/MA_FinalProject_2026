extends NinePatchRect
class_name UIstatbox

signal increase_stat(stat)
signal decrease_stat(stat)

enum STAT{STR,DEX,VIT,MAG,DEF,LUK,FREE}
@export var stat:STAT

func _on_mouse_entered() -> void:
	#emit_signal("show_abilitydata",data)
	print("showing ability desc")
	get_tree().call_group("description", "stat_description",stat)
