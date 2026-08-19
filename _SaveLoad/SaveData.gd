extends Resource
class_name SaveDataResource


@export_category('CURRENT PLAYER DATA')
@export var p1_class:StatComponent = load("res://Resources/Units/Player/Stats_Civilian.tres")
@export var p1_weapon:ItemData_Gear
@export var p1_armour:ItemData_Gear
@export var p1_trinket:ItemData
@export var p1_trinket_slot_stacksize:= 0
@export var p1_equipped_abilities:Array[AbilityData] = [load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")]
@export var p1_ability_usesB1234WAT:Array[int] = [999,0,0,0,0,0,0,0] #1234WAT
@export var p1_HP:int
@export var p1_level:=1
@export var p1_XP:=0
@export var p1_investedStrDexVitMagDefLuk:Array[int] = [0,0,0,0,0,0] 
@export var p1_free_stats := 5

@export var player_inventory = [[load("res://Resources/Items/Consumables/HealthPotion_Small.tres"),3]] #[ITEM_ID,AMOUNT]
@export var inventory_size = 10
@export var player_gold = 999

@export var is_in_dungeon := false
@export var is_in_hub := false
@export var is_in_craftingroom := false
@export var player_hub_location = 0

@export var TileID_NamedInventory = [["TEST",0],["FIRE",4],["WATER",4],["EARTH",4],["AIR",4],["FORCE",4],\
["VOLCANO",0],["ISLANDS",0],["MESA",0],["SKY_ISLANDS",0],\
["RIVER",0],["LAKE",0],["ROUND_ROOMS",0],["DENSE_LAYOUT",0],["SPARSE_LAYOUT",0],["ALTERNATING_SIZE_ROOMS",0],["SMALL_ROOMS",0],["LARGE_ROOMS",0],\
["CONSUMABLES",0],["GEAR",0],["LOCKBOXES",0],["WEAPONS",0],["ARMOUR",0],["TRINKETS",0],\
["VANGUARD",0],["WARRIOR",0],["MAGE",0],["ROGUE",0],["HEALER",0],["JESTER",0],\
["INCREASED_MOB_DENSITY",0],["INCREASED_GOLD",0],["INCREASED_XP",0],["DECREASED_MOB_DENSITY",0],["DECREASED_GOLD",0],["DECREASED_XP",0],\
["BEASTS",0],["ELEMENTALS",0],["UNDEAD",1],["CONSTRUCTS",0],["MORTALS",0],["WILDLINGS",0],\
["TREASURE_ROOM",0],["MINI_BOSS",0],["MONSTER_HOUSE",0],\
["T1_BOSS",0],["T1_FIREBOSS",0],["T1_WATERBOSS",0],["T1_EARTHBOSS",0],["T1_AIRBOSS",0],["T1_FORCEBOSS",0],\
["T2_BOSS",0],["T2_QUADBOSS",0],["T2_FORCEBOSS",0]]

@export_category('CURRENT DUNGEON DATA')
@export var Affinity_Fire = 0
@export var Affinity_Water = 0
@export var Affinity_Earth = 0
@export var Affinity_Air = 0
@export var Affinity_Force = 0
@export var Affinity_Light = 0
@export var Affinity_Dark = 0

@export var Biome_Test = 0
@export var Biome_Volcano = 0
@export var Biome_Island = 0
@export var Biome_Mesa = 0
@export var Biome_Skyland = 0

@export var EnvFeature_River = 0
@export var EnvFeature_Lake = 0
@export var EnvFeature_Flooded = 0
@export var EnvFeature_Barren = 0

@export var Halls_DeadEnds = 0
@export var Rooms_Round = 0
@export var Rooms_DenseLayout = 0
@export var Rooms_SparceLayout = 0
@export var Rooms_AlternatingSize = 0
@export var Rooms_Small = 0
@export var Rooms_Large = 0

@export var ItemType_Gold = 0
@export var ItemType_Tiles = 0
@export var ItemType_Consumable = 0
@export var ItemType_Gear = 0
@export var ItemType_Lockboxes = 0
@export var ItemType_KeyItem = 0

@export var ItemMods_SpawnRate = 0

@export var GearType_Weapon = 0
@export var GearType_Armour = 0
@export var GearType_Trinket = 0

@export var Class_Vanguard = 0
@export var Class_Warrior = 0
@export var Class_Mage = 0
@export var Class_Rogue = 0
@export var Class_Healer = 0
@export var Class_Jester = 0

@export var MobType_Beast = 0
@export var MobType_Elemental = 0
@export var MobType_Undead = 0
@export var MobType_Construct = 0
@export var MobType_Mortal = 0
@export var MobType_Wildling = 0

@export var MobMods_SpawnRate = 0
@export var MobMods_Level = 0
@export var MobMods_EXP = 0
@export var MobMods_Gold = 0
@export var MobMods_Gear = 0

@export var UniqueRooms_TreasureVault = 0
@export var UniqueRooms_MonsterHouse = 0

@export var Boss_T0_Roaming = 0
@export var Boss_T0_Mini = 0
@export var Boss_T1_Generic = 0
@export var Boss_T1_Fire = 0
@export var Boss_T1_Water = 0
@export var Boss_T1_Earth = 0
@export var Boss_T1_Wind = 0
@export var Boss_T1_Force = 0
@export var Boss_T2_Generic = 0
@export var Boss_T2_QuadElement = 0
@export var Boss_T2_Force = 0

@export var extra_floors = 0
@export var has_boss := false

#enum FINAL_FLOOR {N_A,MON_HOUSE,MINI_BOSS,BOSS}
@export var final_floor_layout:UniqueRoomData
@export var safe_room_floor_layout:UniqueRoomData
@export var boss:StatComponent
@export var mini_bosses:Array[StatComponent]
@export var elites = Boss_T0_Roaming
@export var minis = Boss_T0_Mini
@export var houses = UniqueRooms_MonsterHouse
@export var vaults = UniqueRooms_TreasureVault
@export var safe_floors:Array[int] = []
@export var floors_special_features = []
@export var final_floor:= 0
@export var PRESET_Recipie := false

@export var crafting_tier:= 0

@export var AREA_LEVEL := 1
@export var UNIT_LEVEL_Boost := 0
@export var max_wandering_units := 5
@export var max_floors: = 5
@export var current_floor: = 0

@export var room_attempts = 25
@export var interconnectivity = 4.0#0-10 range7
@export var rounded = false
@export var spawn_river =  false
@export var flooded:bool = false
@export var river_tile = 'WATER'
@export var flood_tile = 'WATER'
@export var max_size = 15
@export var min_size = 5
@export var level_size:=Vector2i(30,30)

@export var floor_biome:Biome
@export var Common_Enemies:Array[StatComponent]
@export var Rare_Enemies:Array[StatComponent]
@export var Common_Items:Array[ItemData]
@export var Rare_Items:Array[ItemData]
@export var Unique_Rooms:Array[UniqueRoomData]

@export_category('STORED PLAYER DATA')
@export var stored_character_data:Dictionary = {
	"Civilian":{
		'statComp':"res://Resources/Units/Player/Stats_Civilian.tres",
		'weapon':null,
		'armour':null,
		'trinket':null,
		'trinket_slot_stacksize': 0,
		'equipped_abilities':["res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres"],
		'level':1,
		'XP':0,
		'investedStrDexVitMagDefLuk':[0,0,0,0,0,0] ,
		'free_stats':5,
		},
	"Vanguard":{
		'statComp':"res://Resources/Units/Player/Stats_Vanguard.tres",
		'weapon':null,
		'armour':null,
		'trinket':null,
		'trinket_slot_stacksize': 0,
		'equipped_abilities':["res://Resources/Abilities/DEF_base/10_Thorn_Shield.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres"],
		'level':1,
		'XP':0,
		'investedStrDexVitMagDefLuk':[0,0,0,0,0,0] ,
		'free_stats':5,
		},
	"Warrior":{
		'statComp':"res://Resources/Units/Player/Stats_Warrior.tres",
		'weapon':null,
		'armour':null,
		'trinket':null,
		'trinket_slot_stacksize': 0,
		'equipped_abilities':["res://Resources/Abilities/STR_base/10_Heavy_Chop.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleePhys.tres"],
		'level':1,
		'XP':0,
		'investedStrDexVitMagDefLuk':[0,0,0,0,0,0] ,
		'free_stats':5,
		},
	"Mage":{
		'statComp':"res://Resources/Units/Player/Stats_Mage.tres",
		'weapon':null,
		'armour':null,
		'trinket':null,
		'trinket_slot_stacksize': 0,
		'equipped_abilities':["res://Resources/Abilities/MAG_base/10_Cone_of_Embers.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_RangedMag.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_RangedMag.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_RangedMag.tres"],
		'level':1,
		'XP':0,
		'investedStrDexVitMagDefLuk':[0,0,0,0,0,0] ,
		'free_stats':5,
		},
	"Rogue":{
		'statComp':"res://Resources/Units/Player/Stats_Ranger.tres",
		'weapon':null,
		'armour':null,
		'trinket':null,
		'trinket_slot_stacksize': 0,
		'equipped_abilities':["res://Resources/Abilities/DEX_base/10_Piercing_Shot.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_RangedPhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_RangedPhys.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_RangedPhys.tres"],
		'level':1,
		'XP':0,
		'investedStrDexVitMagDefLuk':[0,0,0,0,0,0] ,
		'free_stats':5,
		},
	"Healer":{
		'statComp':"res://Resources/Units/Player/Stats_Healer.tres",
		'weapon':null,
		'armour':null,
		'trinket':null,
		'trinket_slot_stacksize': 0,
		'equipped_abilities':["res://Resources/Abilities/VIT_base/10_Healing_Touch.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleeMag.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleeMag.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleeMag.tres"],
		'level':1,
		'XP':0,
		'investedStrDexVitMagDefLuk':[0,0,0,0,0,0] ,
		'free_stats':5,
		},
	"Jester":{
		'statComp':"res://Resources/Units/Player/Stats_Jester.tres",
		'weapon':null,
		'armour':null,
		'trinket':null,
		'trinket_slot_stacksize': 0,
		'equipped_abilities':["res://Resources/Abilities/LUK_base/10_Increase_Precision.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleeMag.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleeMag.tres","res://Resources/Abilities/_basic_attacks/BasicAttack_MeleeMag.tres"],
		'level':1,
		'XP':0,
		'investedStrDexVitMagDefLuk':[0,0,0,0,0,0] ,
		'free_stats':8,
		},
}

@export_category('HUB DATA')
@export var bank_gold_val := 0
@export var BankInventory_Resourcestack = [[load("res://Resources/Items/Consumables/ManaPotion.tres"),1]]
@export var BankInventory_size = 999
@export var is_portal_open = false



@export_category('PROGRESS KEYS')
@export var checkpoint_persistance_keys:Dictionary = {
	"reached_lvl_5":false,
	"reached_lvl_10":false,
	"reached_lvl_15":false,
	"reached_lvl_20":false,
	"reached_lvl_25":false,
	
	"1stdrop_minitile":false,
	"1stdrop_t1bosstile":false,
	"1stdrop_t2bosstile":false,
	
	"unlocked_recipe_monsterhouse":true,
	"unlocked_recipe_treasurevault":false,
	"unlocked_recipe_miniboss":false,
	"unlocked_recipe_forceboss":false,
	"unlocked_recipe_fireboss":false,
	"unlocked_recipe_waterboss":false,
	"unlocked_recipe_earthboss":false,
	"unlocked_recipe_airboss":false,
	"unlocked_recipe_quadboss":false,
	"unlocked_recipe_forceboss2":false,
	
	"defeated_t0_miniboss":false,
	"defeated_t1_forceboss":false,
	"defeated_t1_fireboss":false,
	"defeated_t1_waterboss":false,
	"defeated_t1_earthboss":false,
	"defeated_t1_airboss":false,
	"defeated_t2_quadboss":false,
	"defeated_t2_forceboss":false,
	}
