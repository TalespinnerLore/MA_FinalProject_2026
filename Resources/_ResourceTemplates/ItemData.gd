extends Resource
class_name ItemData

enum RARITIES {BASIC,RARE,ELITE,UNIQUE}
enum ITEM_TYPE {GOLD,TILE,CONSUMABLE,GEAR,LOCKBOX,KEY_ITEM}
enum CLASS {NONE,VANGUARD,WARRIOR,MAGE,ROGUE,HEALER,JESTER}

@export var max_stack:= 1
@export var icon:Texture2D
@export var ITEM_ID:int

@export var rarity:RARITIES
@export var ItemType:ITEM_TYPE
@export var Class_Bias:CLASS

@export var Affinity_Fire = 0
@export var Affinity_Water = 0
@export var Affinity_Earth = 0
@export var Affinity_Air = 0
@export var Affinity_Force = 0
@export var Affinity_Light = 0
@export var Affinity_Dark = 0

@export var STR_DEX_VIT_MAG_DEF_LUK = '<- reminder text variable'
@export var BaseStats_required = [0,0,0,0,0,0] #[STR,DEX,VIT,MAG,DEF,LUK]
