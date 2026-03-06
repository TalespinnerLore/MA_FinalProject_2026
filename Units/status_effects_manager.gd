extends Node

func has_stack(effect_name):
	for s_e in get_children():
		if s_e.effect_name == effect_name:
			return true
	return false
