extends Resource
class_name ItemData

enum RARITIES {BASIC,RARE,ELITE,UNIQUE}
enum ITEM_TYPE {GOLD,TILE,CONSUMABLE,GEAR,LOCKBOX,KEY_ITEM}
enum CLASS {NONE,VANGUARD,WARRIOR,MAGE,ROGUE,HEALER,JESTER}

enum GEAR_TYPE {N_A,ARMOUR,WEAPON,TRINKET}
enum CONS_TYPE {N_A,EDIBLE,THROWING,KEY,OTHER}

@export var ItemName := ''
@export var max_stack:= 1
@export var icon:Texture2D
@export var ITEM_ID:int
@export var TILE_ID:= 0

@export var ItemAbility:AbilityData = preload("res://Resources/Abilities/_ItemAbilities/---.tres")
@export var throw_range:= 3

@export var DESCRIPTION = 'Replace this with actual description...'

@export var rarity:RARITIES
@export var ItemType:ITEM_TYPE
@export var GearType:GEAR_TYPE
@export var ConsType:CONS_TYPE
@export var Class_Bias:CLASS
 
@export var Affinity_Fire := false
@export var Affinity_Water := false
@export var Affinity_Earth := false
@export var Affinity_Air := false
@export var Affinity_Force := false
@export var Affinity_Light := false
@export var Affinity_Dark := false

@export var STR_NEEDED:= 0
@export var DEX_NEEDED:= 0
@export var VIT_NEEDED:= 0
@export var MAG_NEEDED:= 0
@export var DEF_NEEDED:= 0
@export var LUK_NEEDED:= 0
