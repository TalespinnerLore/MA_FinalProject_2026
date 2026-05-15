extends Control
class_name DialogueManager

func _ready() -> void:
	if get_parent() != get_tree().get_first_node_in_group("Player"):
		push_error("Dialogue not on player.")
		queue_free()

enum ITEM_ACTION{CONSUME,EQUIP,DROP}
var box_visible := false
@onready var labeltext = $ColorRect/Label2.text

var display_text:String
var text_to_display = ''

func reset_display_text():
	text_to_display = ''

func display_text_lines():
	var str_array = text_to_display.rsplit("\n",true,999)
	for line in str_array:
		labeltext = line
		await get_tree().create_timer(0.2).timeout
	reset_display_text()

func show_unit_using_ability(source_unitname,ab_name):
	text_to_display += str(source_unitname," used ",ab_name,"\n")
	
func show_ability_use_result(source_unitname,hit_unitname,miss:bool,crit:bool,damage:int,damage_negated:int,effects_applied:Array[StatusEffectData]):
	if miss:
		text_to_display += str("Miss!\n")
	elif crit:
		text_to_display += str("Critical Hit!\n")
	
	if damage > 0:
		text_to_display += str(damage," damage (",damage_negated," negated)\n",damage-damage_negated," dealt to ",hit_unitname,".\n")
	elif  damage < 0:
		text_to_display += str(damage," healed (",damage_negated," resisted)\n",hit_unitname," recovers ", damage-damage_negated," HP.\n")
	
	if effects_applied.size() > 0:
		for status in effects_applied:
			if status.is_negative:
				text_to_display += str(hit_unitname," was afflicted with ",status.effect_name,".\n")
			else:
				text_to_display += str(hit_unitname," gained ",status.effect_name,".\n")
	display_text_lines()

func show_item_use_result(unitname:String, item_data:ItemData, item_action:ITEM_ACTION):
	text_to_display += str(" IMPLEMENT ITEM USE DIALOGUE \n")
	display_text_lines()

func show_status_effect_text(unitname:String,data:StatusEffectData,stacks:int,damage:int,turns_left:int):
	if damage > 0:
		text_to_display += str(unitname," takes ",damage," damage from ",data.effect_name,".\n")
	elif  damage < 0:
		text_to_display += str(unitname," heals ",damage," HP from ",data.effect_name,".\n")
	
	if turns_left <= 0:
		if data.is_negative:
			text_to_display += str(unitname," is no longer ",data.effect_name,".\n")
		else:
			text_to_display += str(unitname," no longer has ",data.effect_name,".\n")
	display_text_lines()
