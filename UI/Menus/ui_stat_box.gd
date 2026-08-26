extends NinePatchRect
class_name UIstatbox

signal increase_stat(statnum:STAT)
signal decrease_stat(statnum:STAT)
signal allocating_stats(is_true:bool)

enum STAT{STR,DEX,VIT,MAG,DEF,LUK,FREE}
@export var stat:STAT
@export var is_allocating_stats:=false

func _on_mouse_entered() -> void:
	#emit_signal("show_abilitydata",data)
	print("showing ability desc")
	get_tree().call_group("description", "stat_description",stat)



func _on_minus_button_pressed() -> void:
	#emit_signal("decrease_stat",stat)
	print("decreast stat: ",stat)
	decrease_stat.emit(stat,false)
	pass # Replace with function body.


func _on_plus_button_pressed() -> void:
	#emit_signal("increase_stat",stat)
	print("increast stat: ",stat)
	increase_stat.emit(stat,true)


func _on_usepoints_button_pressed() -> void:
	print("usebutton ",get_child(3).text)
	is_allocating_stats = ! is_allocating_stats
	emit_signal("allocating_stats",is_allocating_stats)
	if ! is_allocating_stats:
		$"../StatBox7/Label2".text = ' USE'
		$"../StatBox7/Label2".set("theme_override_colors/font_color",Color(0.988,0.945,0.796))
		#get_parent().save_allocated_points()
	else:
		$"../StatBox7/Label2".text = ' SAVE'
		$"../StatBox7/Label2".set("theme_override_colors/font_color",Color.SPRING_GREEN)
