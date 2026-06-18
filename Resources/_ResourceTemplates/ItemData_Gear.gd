extends ItemData
class_name ItemData_Gear

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
