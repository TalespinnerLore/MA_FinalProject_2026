extends Control
class_name UI_AbilitySelector

@onready var Abilities_STR:ResourceGroup = load("res://Resources/_Resource_x_Groups/Abilities_STR.tres")
@onready var Abilities_DEX:ResourceGroup = load("res://Resources/_Resource_x_Groups/Abilities_DEX.tres")
@onready var Abilities_VIT:ResourceGroup = load("res://Resources/_Resource_x_Groups/Abilities_VIT.tres")
@onready var Abilities_MAG:ResourceGroup = load("res://Resources/_Resource_x_Groups/Abilities_MAG.tres")
@onready var Abilities_DEF:ResourceGroup = load("res://Resources/_Resource_x_Groups/Abilities_DEF.tres")
@onready var Abilities_LUK:ResourceGroup = load("res://Resources/_Resource_x_Groups/Abilities_LUK.tres")

enum STATS{STR,DEX,VIT,MAG,DEF,LUK}
@export var abilities:Array[AbilityData]
const abilitybox = preload("res://UI/Menus/UI Components/ability_box.tscn")
const seperator_label = preload("res://UI/Menus/UI Components/seperator_label.tscn")
var basic_attack:AbilityData
var selected_ability_slot:int = 0
var selected_ability:AbilityData
@export var selected_stat:STATS

enum Pnum {P1,P2,P3,P4}
@export var PlayerUnit:Pnum
var autostats 

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	#load_player_data()
	#await get_tree().create_timer(2).timeout
	#change_statpage(true)
	#for ability:AbilityData in abilities:
	#	print(ability.ability_name)
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("AbilitySwap"):
		open_close()

func open_close():
	load_player_data()
	self.visible = ! self.visible
	pause_level()

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused

func load_player_data():
	$StatAbilityBox/StatBoxContainer.show_hide_plusbtns(false)
	for i in 6:
		$StatAbilityBox/StatBoxContainer.show_hide_minusbtn(false,i)
	var index = 0
	var classdata = PlayerStats.p1_class
	basic_attack = classdata.BasicAttack
	$StatAbilityBox/NameLabel.text = str('Test McTestface\n LVL ',PlayerStats.p1_level,' ',classdata.UnitName)
	autostats = classdata.get_levelup_stats(PlayerStats.p1_level)
	for box in $StatAbilityBox/AbilityBoxContainer.get_children():
		box.data = PlayerStats.p1_equipped_abilities[index]
		box.uses_remaining = PlayerStats.p1_ability_usesB1234WAT[index+1]
		box.set_textures()
		index+=1
	$StatAbilityBox/StatBoxContainer/StatBox/Number.text = str(PlayerStats.p1_investedStrDexVitMagDefLuk[0]+autostats[0])
	$StatAbilityBox/StatBoxContainer/StatBox2/Number.text = str(PlayerStats.p1_investedStrDexVitMagDefLuk[1]+autostats[1])
	$StatAbilityBox/StatBoxContainer/StatBox3/Number.text = str(PlayerStats.p1_investedStrDexVitMagDefLuk[2]+autostats[2])
	$StatAbilityBox/StatBoxContainer/StatBox4/Number.text = str(PlayerStats.p1_investedStrDexVitMagDefLuk[3]+autostats[3])
	$StatAbilityBox/StatBoxContainer/StatBox5/Number.text = str(PlayerStats.p1_investedStrDexVitMagDefLuk[4]+autostats[4])
	$StatAbilityBox/StatBoxContainer/StatBox6/Number.text = str(PlayerStats.p1_investedStrDexVitMagDefLuk[5]+autostats[5])
	$StatAbilityBox/StatBoxContainer/StatBox7/Label.text = str("Free Stats - ",PlayerStats.p1_free_stats)
	load_abilities(selected_stat)
	

func change_statpage(forward:bool):
	if forward:
		selected_stat += 1
	else:
		selected_stat -= 1
	if selected_stat < 0:
		selected_stat = 5
	elif selected_stat > 5:
		selected_stat = 0
	load_abilities(selected_stat)

func show_hide_plusbtns(show:bool):
	for i in 6:
		var box:UIstatbox = get_child(i)
		box.get_child(3).visible = show

func show_hide_minusbtn(show:bool,index:int):
	var box:UIstatbox = get_child(index)
	box.get_child(2).visible = show

func show_player_stats(stats:Array): #of ints
	print('stats needed:',stats)
	for box in $StatAbilityBox/StatBoxContainer.get_children():
		box.visible = false
	for index in stats.size():
		if stats[index] > 0:
			match index:
				0:
					$StatAbilityBox/StatBoxContainer/StatBox.visible = true
				1:
					$StatAbilityBox/StatBoxContainer/StatBox2.visible = true
				2:
					$StatAbilityBox/StatBoxContainer/StatBox3.visible = true
				3:
					$StatAbilityBox/StatBoxContainer/StatBox4.visible = true
					#print('need mag')
				4:
					$StatAbilityBox/StatBoxContainer/StatBox5.visible = true
				5:
					$StatAbilityBox/StatBoxContainer/StatBox6.visible = true
	if PlayerStats.p1_free_stats > 0:
		$StatAbilityBox/StatBoxContainer/StatBox7.visible = true

func clear_abilities():
	for child in $AbilitySelectionBox/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	abilities.clear()
	return

func load_abilities(stat_index:STATS):
	clear_abilities()
	#print('child count:',$AbilitySelectionBox/ScrollContainer/VBoxContainer.get_child_count(),$AbilitySelectionBox/ScrollContainer/VBoxContainer.get_children())
	var seperator_label_text = ''
	match stat_index:
		0:
			Abilities_STR.load_all_into(abilities)
			seperator_label_text = ' STR -'
			$AbilitySelectionBox/StatAbilityLabel.text = 'ABILITIES\n- STR -'
			show_player_stats([0])
		1:
			Abilities_DEX.load_all_into(abilities)
			seperator_label_text = ' DEX -'
			$AbilitySelectionBox/StatAbilityLabel.text = 'ABILITIES\n- DEX -'
			show_player_stats([1])
		2:
			Abilities_VIT.load_all_into(abilities)
			seperator_label_text = ' VIT -'
			$AbilitySelectionBox/StatAbilityLabel.text = 'ABILITIES\n- VIT -'
			show_player_stats([2])
		3:
			Abilities_MAG.load_all_into(abilities)
			seperator_label_text = ' MAG -'
			$AbilitySelectionBox/StatAbilityLabel.text = 'ABILITIES\n- MAG -'
			show_player_stats([3])
		4:
			Abilities_DEF.load_all_into(abilities)
			seperator_label_text = ' DEF -'
			$AbilitySelectionBox/StatAbilityLabel.text = 'ABILITIES\n- DEF -'
			show_player_stats([4])
		5:
			Abilities_LUK.load_all_into(abilities)
			seperator_label_text = ' LUK -'
			$AbilitySelectionBox/StatAbilityLabel.text = 'ABILITIES\n- LUK -'
			show_player_stats([5])
		
	sort_abilities(stat_index)
	for i in range(0,abilities.size()):
		if i == 0 or abilities[i].BaseStats_required[stat_index] < abilities[i-1].BaseStats_required[stat_index]:
			var newlabel = seperator_label.instantiate()
			newlabel.text = str('- ',abilities[i].BaseStats_required[stat_index],seperator_label_text)
			$AbilitySelectionBox/ScrollContainer/VBoxContainer.add_child(newlabel)
		var new_box = abilitybox.instantiate()
		new_box.data = abilities[i]
		print(new_box.data)
		new_box.uses_remaining = abilities[i].max_uses
		new_box.set_textures()
		$AbilitySelectionBox/ScrollContainer/VBoxContainer.add_child(new_box)
		pass
	
	show_usable_abilities()

func sort_abilities(stat_index:STATS):
	for box in $AbilitySelectionBox/ScrollContainer/VBoxContainer.get_children():
		print(box,' ')
	var main_statreq:Array[int] = []
	for ability in abilities:
		main_statreq.append(ability.BaseStats_required[stat_index])
	main_statreq.sort()
	main_statreq.reverse()
	var ordered_abilites:Array[AbilityData]
	for statreq in main_statreq:
		for ability in abilities:
			if ability.BaseStats_required[stat_index] == statreq:
				ordered_abilites.append(ability)
				abilities.erase(ability)
				break #should only break the innner loop
	abilities = ordered_abilites

func show_usable_abilities():
	await get_tree().create_timer(0.1).timeout
	for box in $AbilitySelectionBox/ScrollContainer/VBoxContainer.get_children():
		if box is UI_abilitybox:
			print(box.data)
			for stat in 6:
				print('stat:',stat,' req:',box.data.BaseStats_required[stat],' have:',PlayerStats.p1_investedStrDexVitMagDefLuk[stat]+autostats[stat])
				if box.data.BaseStats_required[stat] > \
				PlayerStats.p1_investedStrDexVitMagDefLuk[stat]+autostats[stat]:
					print(box.data.BaseStats_required[stat],' > ',PlayerStats.p1_investedStrDexVitMagDefLuk[stat]+autostats[stat])
					box.self_modulate = Color.DIM_GRAY
					box.equipable = false
					break
				else:
					box.equipable = true
					box.self_modulate = Color.WHITE
			pass

func ability_description(data:AbilityData):
	var is_equipped = false
	for box:Node in $StatAbilityBox/AbilityBoxContainer.get_children():
		if box.data == data:
			is_equipped = true
			selected_ability_slot = box.get_index()
			break #checks if this is an equipped ability, and if not preps it to be slotted in.
	if not is_equipped:
		selected_ability = data
	print(data.BaseStats_required)
	show_player_stats(data.BaseStats_required)
	
	print("abilityname: ",data.ability_name)
	var title = $DescriptionBox/NameOfThingLabel
	var desc = $DescriptionBox/DescriptionLabel
	#ENUM_NAME.keys()[enum_val]
	title.text = str('- ABILITY -\n',data.ability_name)
	desc.text = '' 
	if data.damaging:
		desc.text += (str('Damaging '))
	elif data.healing:
		desc.text += (str('Healing '))
	elif data.creates_shield:
		desc.text += (str('Shielding '))
	desc.text+=(str(AbilityData.ElementType.keys()[data.element]))
	match data.damage_type:
		0:
			desc.text += (str(' PHYSICAL Attack.\n'))
		1:
			desc.text += (str(' PHYSICAL MELEE Attack.\n'))
		2:
			desc.text += (str(' PHYSICAL RANGED Attack.\n'))
		3:
			desc.text += (str(' MAGICAL Spell.\n'))
		4:
			desc.text += (str(' MAGICAL MELEE Spell.\n'))
		5:
			desc.text += (str(' MAGICAL RANGED Spell.\n'))
		6:
			desc.text += (str(' Ability.\n'))
	
	desc.text += (str('Area of Effect: ',AbilityData.TargetType.keys()[data.targeting],'\n',\
	'Range: ',data.range,'\n'))
	if data.inflict_status.size() > 0:
		desc.text += (str('Applies ',))
		for se in data.inflict_status:
			desc.text += (str(se.effect_name,' '))
		desc.text += (str('.\n'))
	desc.text += (str('Valid Targets: ',AbilityData.Validity.keys()[data.valid_target],'\n'))
	desc.text += str('\nRequired Stats:\n',\
					'STR: ',data.BaseStats_required[0],'   DEX: ',data.BaseStats_required[1],'\n',\
					'VIT: ',data.BaseStats_required[2],'   MAG: ',data.BaseStats_required[3],'\n',\
					'DEF: ',data.BaseStats_required[4],'   LUK: ',data.BaseStats_required[5],'\n')
	highlight_selected()


func stat_description(statindex:int):
	var title = $DescriptionBox/NameOfThingLabel
	var desc = $DescriptionBox/DescriptionLabel
	match statindex:
		0:
			title.text = '- STAT -\n Strength'
			desc = desc_str
		1:
			title.text = '- STAT -\n Dexterity'
			desc = desc_dex
		2:
			title.text = '- STAT -\n Vitality'
			desc = desc_vit
		3:
			title.text = '- STAT -\n Magic'
			desc = desc_mag
		4:
			title.text = '- STAT -\n Defence'
			desc = desc_def
		5:
			title.text = '- STAT -\n Luck'
			desc = desc_luk
		6:
			title.text = '- STAT -\n Free Stats'
			desc = desc_free
	pass

var desc_str = "Strength (STR) provides the base value for a unit's PHYSICAL damage equal to total points invested. \n
It also provides a 2% multiplier to MELEE damage per point invested. \n"

var desc_dex = "Dexterity (DEX) provides the base value for a unit's evasion and critical hit rate according to the difference between two units. \n
It also provides a 2% multiplier to RANGED damage per point invested. \n"

var desc_vit = "Vitality (VIT) provides 2 additional HP to a unit per point invested. \n
It also provides a 2% multiplier to HEALING, BUFF, and DEBUFF abilities. \n"

var desc_mag = "Magic (MAG) provides the base value for a unit's MAGICAL damage equal to total points invested. \n
It also provides 75% of that value towards a unit's base value for MAGICAL defence, with DEF providing 25%. \n"

var desc_def = "Defence (DEF) provides the base value for a unit's PHYSICAL defence, equal to total points invested,
as well as 25% of that value towardsa unit's base value for MAGICAL defence, with MAG providing 75%. \n"

var desc_luk = "Luck (LUK) provides a 1% chance to reroll negative outcomes or random rolls for the player. \n
Seriously, that's it. \n"

var desc_free = "Freely applicable stat points that can be allocated as the player wishes. \n"

func highlight_selected():
	for box:UI_abilitybox in $StatAbilityBox/AbilityBoxContainer.get_children():
		if box.get_index() == selected_ability_slot:
			box.set_bg(true)
		else:
			box.set_bg(false)
	for box in $AbilitySelectionBox/ScrollContainer/VBoxContainer.get_children(): 
		if box is UI_abilitybox:
			if box.data == selected_ability:
				box.set_bg(true)
			else:
				box.set_bg(false)


func _on_equip_button_pressed() -> void:
	var works = true
	for stat in 6:
		if selected_ability.BaseStats_required[stat] > PlayerStats.p1_investedStrDexVitMagDefLuk[stat]+autostats[stat]:
			works  = false
			break
	if works:
		PlayerStats.p1_equipped_abilities[selected_ability_slot] = selected_ability
		load_player_data()
	pass # Replace with function body.


func _on_unequip_button_pressed() -> void:
	PlayerStats.p1_equipped_abilities[selected_ability_slot] = basic_attack
	load_player_data()
	pass # Replace with function body.


func _on_left_button_pressed() -> void:
	change_statpage(false)
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	change_statpage(true)
	pass # Replace with function body.
