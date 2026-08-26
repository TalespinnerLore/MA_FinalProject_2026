#@tool
class_name StatComponent
extends Resource

@export var Sprite:Texture2D
@export var BasicAttack:AbilityData
@export var Attacks:Array[AbilityData] = [load("res://Resources/Abilities/_basic_attacks/BasicAttack_MeleeMag.tres"),\
load("res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres"),\
load("res://Resources/Abilities/_basic_attacks/BasicAttack_RangedMag.tres"),\
load("res://Resources/Abilities/_basic_attacks/BasicAttack_RangedPhys.tres")]
@export var UnitName:String
@export var is_large_unit := false
@export var is_rare_spawn := false
@export var is_miniboss := false
@export var is_boss := false
@export var is_t2_boss := false
enum TYPE{MORTAL,UNDEAD,ELEMENTAL,CONSTRUCT,BEAST,WILDLING}
@export var CreatureType:TYPE
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
@export var Element:ElementType = ElementType.FORCE
#@export var drop_held_equipment := false
#@export var unit_specific_drops:Array[ItemData]

@export var elem_palettes:Array[Texture2D]

@export var must_drop_items:Array[ItemData]
@export var chance_drop_items:Array[ItemData]

@export_category('Level-Up Stats')
@export var STR_up:int = 0
@export var DEX_up:int = 0
@export var VIT_up:int = 0
@export var MAG_up:int = 0
@export var DEF_up:int = 0
@export var LUK_up:int = 0
@export var Free_Stats:int = 0

@export_category('Base Stats')
#Base Stats
@export var Base_HP = 10
@export var STR:int = 5
@export var DEX:int = 5
@export var VIT:int = 5
@export var MAG:int = 5
@export var DEF:int = 5
@export var LUK:int = 5

@export_category('Calculated Stats')
#CalculatedStats
@export var HP_Max_withVIT = Base_HP+(2*VIT)
#@export var HP_Current = HP_Max
@export var Base_Phys_ATK = 5.0
@export var Base_Mag_ATK = 5.0
@export var Base_Phys_DEF = 5.0
@export var Base_Mag_DEF = 5.0
@export var Base_Evasion = 5.0
@export var Heal_Buff_Mult = 1.1
@export var Melee_Mult = 1.1
@export var Ranged_Mult = 1.1
@export var Def_Mult = 1.1
@export var Reroll_Chance = 0.05

@export_category('Stat Boosts')
#Base Stat Boosts
@export var STR_boost:int = 0
@export var DEX_boost:int = 0
@export var VIT_boost:int = 0
@export var MAG_boost:int = 0
@export var DEF_boost:int = 0
@export var LUK_boost:int = 0

#CalculatedStatBoosts
@export var HP_Max_boost = 0
@export var Phys_ATK_boost = 0
@export var Mag_ATK_boost = 0
@export var Phys_DEF_boost = 0
@export var Mag_DEF_boost = 0
@export var Evasion_boost = 0
@export var CritChance_boost = 0.0 #APPLY AT CRIT CHANCE CALCULATION
@export var Heal_Buff_Mult_boost = 0.0
@export var Melee_Mult_boost = 0.0
@export var Ranged_Mult_boost = 0.0
@export var Def_Mult_boost = 0.0
@export var Reroll_Chance_boost = 0.00


func get_levelup_stats(level):
	var BaseStats = [STR_up,DEX_up,VIT_up,MAG_up,DEF_up,LUK_up]
	for y in 6:
		BaseStats[y]*=level
	print('lvl',BaseStats)
	var base = [STR,DEX,VIT,MAG,DEF,LUK]
	print('base',base)
	for i in range(6):
		BaseStats[i]+=base[i]
	return BaseStats

func calc_template_stats():
	HP_Max_withVIT = Base_HP + 2*(VIT+VIT_boost)
	Heal_Buff_Mult = 1.0 + 0.02*(VIT+VIT_boost)
	Base_Phys_ATK = STR + STR_boost
	Melee_Mult = 1.0 + 0.02*(STR + STR_boost)
	Base_Evasion = DEX+DEX_boost
	Ranged_Mult = 1.0 + 0.02*(DEX+DEX_boost)
	Base_Mag_ATK = MAG+MAG_boost
	Base_Phys_DEF = DEF+DEF_boost
	Base_Mag_DEF = (Base_Mag_ATK/2.0) + (Base_Phys_DEF/2.0)
	Def_Mult = 1.0 + 0.02*(DEF+DEF_boost)
	Reroll_Chance = 0.01*(LUK+LUK_boost)
	pass

func apply_template_calc_stat_boosts():
	HP_Max_withVIT += HP_Max_boost
	Base_Phys_ATK += Phys_ATK_boost
	Base_Mag_ATK += Mag_ATK_boost
	Base_Phys_DEF += Phys_DEF_boost
	Base_Mag_DEF += Mag_DEF_boost 
	Base_Evasion += Evasion_boost 
	Heal_Buff_Mult += Heal_Buff_Mult_boost 
	Melee_Mult += Melee_Mult_boost
	Ranged_Mult += Ranged_Mult_boost
	Def_Mult += Def_Mult_boost
	Reroll_Chance += Reroll_Chance_boost
	
#func _process(delta:float) -> void:
	#calc_stats()
	#apply_calc_stat_boosts()
