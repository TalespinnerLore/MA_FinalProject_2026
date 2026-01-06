extends Node

class_name TurnQueue

var Active_Unit

func initialize():
	Active_Unit = get_child(0)

# Called when the node enters the scene tree for the first time.
func play_turn():
	await Active_Unit.play_turn()
	var new_index = (Active_Unit.get_index()+1) % get_child_count()
	Active_Unit = get_child(new_index)
