extends Node
class_name StatusEffectManager

func has_stack(effect_name):
	for s_e in get_children():
		if s_e.effect_name == effect_name:
			return true
	return false

func add_stack(effect_name):
	for s_e in get_children():
		if s_e.effect_name == effect_name:
			s_e.stack_amount +=1

func lose_effect_dialogue(effect:StatusEffectData):
	print("make this connect to dialogue ",get_parent().UnitStats.UnitName, " lost ",effect.effect_name)
	pass
