extends Control
class_name DialogueManager

signal action_complete

func _ready() -> void:
	#if get_parent().get_parent() != get_tree().get_first_node_in_group("Player"):
	#	push_error("Dialogue not on player.")
	#	queue_free()
	reset_display_text()
	pass

enum ITEM_ACTION{CONSUME,EQUIP,DROP}
var box_visible := false
@onready var labeltext = $ColorRect/Label2.text

var display_text:String
var text_to_display = ''
var linecount = 0
@export var textspeed := 2

var connected_unit = null

func connect_to_unit(unit):
	#unit.waiting_on_dialogue.connect(signal_complete) <=DIABLED FOR TESTING
	#print("connected to dialogue now")
	connected_unit = unit

func disconnect_unit():
	if is_instance_valid(connected_unit):
		connected_unit.waiting_on_dialogue.disconnect(signal_complete)

func signal_complete():
	#print("recived signal now")
	#print("textt to display check: ",text_to_display)
	await get_tree().create_timer(0.15).timeout
	if text_to_display == '':
		emit_signal("action_complete")
		disconnect_unit()

func reset_display_text():
	$ColorRect.visible = false
	text_to_display = ''
	labeltext = ''
	
func hit_nothing():
	text_to_display += str("Miss! (HIT AIR)\n")
	display_text_lines(true)

func display_text_lines(action_complete:bool):
	$ColorRect.visible = true
	var str_array = text_to_display.rsplit("\n",true,999)
	print("===starting dialogue===")
	for line in str_array:
		#labeltext = line
		linecount+=1
		#if linecount < 3:
		#	$ColorRect/Label2.text = str($ColorRect/Label2.text,line)
		#else:
		#	linecount = 1
		#	$ColorRect/Label2.text = line
		$ColorRect/Label2.text = line
		print("= ",line)
		if line != '':
			if is_instance_valid(get_tree()):
				await get_tree().create_timer(0.25*textspeed).timeout
	reset_display_text()
	print("===ending dialogue===")
	if action_complete:
		emit_signal("action_complete")
		disconnect_unit()

func show_unit_using_ability(source_unitname,ab_name):
	text_to_display += str(source_unitname," used ",ab_name,"\n")
	
func show_ability_use_result(source_unitname,hit_unitname,hit:bool,crit:bool,damage:int,damage_negated:int,effects_applied:Array[StatusEffectData]):
	if ! hit:
		text_to_display += str("Miss!\n")
	elif crit:
		text_to_display += str("Critical Hit!\n")
	
	if damage > 0:
		text_to_display += str(damage," damage dealt to ",hit_unitname,". (",damage_negated," negated)\n")
	elif  damage < 0:
		text_to_display += str(hit_unitname," recovers ",damage," HP. (",damage_negated," resisted)\n")

	
	if effects_applied.size() > 0:
		for status in effects_applied:
			if status.is_negative:
				text_to_display += str(hit_unitname," was afflicted with ",status.effect_name,".\n")
			else:
				text_to_display += str(hit_unitname," gained ",status.effect_name,".\n")
	display_text_lines(true)

func show_item_use_result(unitname:String, item_data:ItemData, item_action:ITEM_ACTION):
	text_to_display += str(" IMPLEMENT ITEM USE DIALOGUE \n")
	display_text_lines(true)

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
	display_text_lines(false)
