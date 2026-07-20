extends Control
class_name UnitInventoryUI

enum Pnum {P1,P2,P3,P4}
@export var PlayerUnit:Pnum
@export var unit:Unit_Instance
var autostats #= classdata.get_levelup_stats(unit.UnitLevel)

func load_data():
	$StatAbilityBox/StatBoxContainer.show_hide_plusbtns(false)
	for i in 6:
		$StatAbilityBox/StatBoxContainer.show_hide_minusbtn(false,i)
	match PlayerUnit:
		Pnum.P1:
			var classdata = PlayerStats.p1_class
			unit = get_tree().get_first_node_in_group("Player")
			unit.set_stats()
			$gearInventoryBox/HPLabel.text = str('HP: ',unit.HP_Current,'/',unit.HP_Max+unit.HP_Max_boost)
			$gearInventoryBox/NameClassLabel.text = str('Test McTestface\n LVL ',unit.UnitLevel,' ',classdata.UnitName)
			autostats = classdata.get_levelup_stats(unit.UnitLevel)
			$gearInventoryBox/PortraitTextureRect.texture = classdata.Sprite
			if PlayerStats.p1_weapon != null:
				$gearInventoryBox/WeaponTextureSlot/WeaponTexture.texture = PlayerStats.p1_weapon.icon
			if PlayerStats.p1_armour != null:
				$gearInventoryBox/ArmourTextureSlot/ArmourTexture.texture = PlayerStats.p1_armour.icon
			if PlayerStats.p1_trinket != null:
				$gearInventoryBox/TrinketTextureSlot/TrinketTexture.texture = PlayerStats.p1_trinket.icon
			var index = 0
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
			
	pass

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CharacterScreen"):
		open_close()


func open_close():
	if not visible:
		load_data()
	self.visible = ! self.visible
	pause_level()

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused

func ability_description(data:AbilityData):
	print("abilityname: ",data.ability_name)
	var title = $DescriptionBox/NameOfThingLabel
	var desc = $DescriptionBox/DescriptionLabel
	#ENUM_NAME.keys()[enum_val]
	title.text = str('-ABILITY-\n',data.ability_name)
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

func item_description(data:ItemData):
	var title = $DescriptionBox/NameOfThingLabel
	var desc = $DescriptionBox/DescriptionLabel
	title.text = str('-ITEM-\n',data.ItemName)
	desc.text = data.DESCRIPTION
	pass

func stat_description(statindex:int):
	var title = $DescriptionBox/NameOfThingLabel
	var desc = $DescriptionBox/DescriptionLabel
	match statindex:
		0:
			title.text = '-STAT-\n Strength'
			desc = desc_str
		1:
			title.text = '-STAT-\n Dexterity'
			desc = desc_dex
		2:
			title.text = '-STAT-\n Vitality'
			desc = desc_vit
		3:
			title.text = '-STAT-\n Magic'
			desc = desc_mag
		4:
			title.text = '-STAT-\n Defence'
			desc = desc_def
		5:
			title.text = '-STAT-\n Luck'
			desc = desc_luk
		6:
			title.text = '-STAT-\n Free Stats'
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


func _on_weapon_texture_mouse_entered() -> void:
	if PlayerStats.p1_weapon != null:
		item_description(PlayerStats.p1_weapon)
func _on_armour_texture_mouse_entered() -> void:
	if PlayerStats.p1_armour != null:
		item_description(PlayerStats.p1_armour)
func _on_trinket_texture_mouse_entered() -> void:
	if PlayerStats.p1_trinket != null:
		item_description(PlayerStats.p1_trinket)
