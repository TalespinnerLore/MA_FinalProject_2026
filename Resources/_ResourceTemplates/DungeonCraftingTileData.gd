extends Resource
class_name DUNGEON_CRAFTING_TILE_DATA

enum RARITIES {BASIC,RARE,ELITE,UNIQUE}
@export var TILE_ID:int
@export var rarity:RARITIES

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
@export var has_boss = false
#var Crafting_Mods = [Boss_T0_Roaming]

func combine_data(data:DUNGEON_CRAFTING_TILE_DATA,adding:bool):
	var i = 1
	if ! adding:
		i = -1
	Affinity_Fire += i*data.Affinity_Fire
	Affinity_Water += i*data.Affinity_Water
	Affinity_Earth += i*data.Affinity_Earth
	Affinity_Air += i*data.Affinity_Air
	Affinity_Force += i*data.Affinity_Force
	Affinity_Light += i*data.Affinity_Light
	Affinity_Dark += i*data.Affinity_Dark

	Biome_Test += i*data.Biome_Test
	Biome_Volcano += i*data.Biome_Volcano
	Biome_Island += i*data.Biome_Island
	Biome_Mesa += i*data.Biome_Mesa
	Biome_Skyland += i*data.Biome_Skyland

	EnvFeature_River += i*data.EnvFeature_River
	EnvFeature_Lake += i*data.EnvFeature_Lake
	EnvFeature_Flooded += i*data.EnvFeature_Flooded
	EnvFeature_Barren += i*data.EnvFeature_Barren

	Halls_DeadEnds += i*data.Halls_DeadEnds
	Rooms_Round += i*data.Rooms_Round
	Rooms_DenseLayout += i*data.Rooms_DenseLayout
	Rooms_SparceLayout += i*data.Rooms_SparceLayout
	Rooms_AlternatingSize += i*data.Rooms_AlternatingSize
	Rooms_Small += i*data.Rooms_Small
	Rooms_Large += i*data.Rooms_Large

	ItemType_Gold += i*data.ItemType_Gold
	ItemType_Tiles += i*data.ItemType_Tiles
	ItemType_Consumable += i*data.ItemType_Consumable
	ItemType_Gear += i*data.ItemType_Gear
	ItemType_Lockboxes += i*data.ItemType_Lockboxes
	ItemType_KeyItem += i*data.ItemType_KeyItem

	ItemMods_SpawnRate += i*data.ItemMods_SpawnRate

	GearType_Weapon += i*data.GearType_Weapon
	GearType_Armour += i*data.GearType_Armour
	GearType_Trinket += i*data.GearType_Trinket

	Class_Vanguard += i*data.Class_Vanguard
	Class_Warrior += i*data.Class_Warrior
	Class_Mage += i*data.Class_Mage
	Class_Rogue += i*data.Class_Rogue
	Class_Healer += i*data.Class_Healer
	Class_Jester += i*data.Class_Jester

	MobType_Beast += i*data.MobType_Beast
	MobType_Elemental += i*data.MobType_Elemental
	MobType_Undead += i*data.MobType_Undead
	MobType_Construct += i*data.MobType_Construct
	MobType_Mortal += i*data.MobType_Mortal
	MobType_Wildling += i*data.MobType_Wildling

	MobMods_SpawnRate += i*data.MobMods_SpawnRate
	MobMods_Level += i*data.MobMods_Level
	MobMods_EXP += i*data.MobMods_EXP
	MobMods_Gold += i*data.MobMods_Gold
	MobMods_Gear += i*data.MobMods_Gear

	UniqueRooms_TreasureVault += i*data.UniqueRooms_TreasureVault
	UniqueRooms_MonsterHouse += i*data.UniqueRooms_MonsterHouse

	Boss_T0_Roaming += i*data.Boss_T0_Roaming
	Boss_T0_Mini += i*data.Boss_T0_Mini
	Boss_T1_Generic += i*data.Boss_T1_Generic
	Boss_T1_Fire += i*data.Boss_T1_Fire
	Boss_T1_Water += i*data.Boss_T1_Water
	Boss_T1_Earth += i*data.Boss_T1_Earth
	Boss_T1_Wind += i*data.Boss_T1_Wind
	Boss_T1_Force += i*data.Boss_T1_Force
	Boss_T2_Generic += i*data.Boss_T2_Generic
	Boss_T2_QuadElement += i*data.Boss_T2_QuadElement
	Boss_T2_Force += i*data.Boss_T2_Force
	extra_floors += i*data.extra_floors
	

var Tile_Crafting_Mods: Dictionary = {"TEST":
								{"ID": 0,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],0],[Global.DG_Mods["ELEMENTS"][1],0],[Global.DG_Mods["ELEMENTS"][2],0],[Global.DG_Mods["ELEMENTS"][3],0],[Global.DG_Mods["ELEMENTS"][4],0],[Global.DG_Mods["ELEMENTS"][5],0],[Global.DG_Mods["ELEMENTS"][6],0]],
								"environ":[[Global.DG_Mods["BIOMES"][0],0],[Global.DG_Mods["BIOMES"][1],0],[Global.DG_Mods["BIOMES"][2],0],[Global.DG_Mods["BIOMES"][3],0],[Global.DG_Mods["BIOMES"][4],0],\
										[Global.DG_Mods["ENV_FEATURES"][0],0],[Global.DG_Mods["ENV_FEATURES"][1],0],[Global.DG_Mods["ENV_FEATURES"][2],0],[Global.DG_Mods["ENV_FEATURES"][3],0],\
										[Global.DG_Mods["ROOMS"][0],0],[Global.DG_Mods["ROOMS"][1],0],[Global.DG_Mods["ROOMS"][2],0],[Global.DG_Mods["ROOMS"][3],0],[Global.DG_Mods["ROOMS"][4],0],[Global.DG_Mods["ROOMS"][5],0]],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],0],[Global.DG_Mods["MOB_MODIFIERS"][1],0],[Global.DG_Mods["MOB_MODIFIERS"][2],0],[Global.DG_Mods["MOB_MODIFIERS"][3],0],[Global.DG_Mods["MOB_MODIFIERS"][4],0],\
										[Global.DG_Mods["MOB_TYPE"][0],0],[Global.DG_Mods["MOB_TYPE"][1],0],[Global.DG_Mods["MOB_TYPE"][2],0],[Global.DG_Mods["MOB_TYPE"][3],0],[Global.DG_Mods["MOB_TYPE"][4],0],[Global.DG_Mods["MOB_TYPE"][5],0]],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],0],[Global.DG_Mods["ITEM_TYPE"][0],0],[Global.DG_Mods["ITEM_TYPE"][1],0],[Global.DG_Mods["ITEM_TYPE"][2],0],[Global.DG_Mods["ITEM_TYPE"][3],0],[Global.DG_Mods["ITEM_TYPE"][4],0],[Global.DG_Mods["ITEM_TYPE"][5],0],\
										[Global.DG_Mods["CLASS"][0],0],[Global.DG_Mods["CLASS"][1],0],[Global.DG_Mods["CLASS"][2],0],[Global.DG_Mods["CLASS"][3],0],[Global.DG_Mods["CLASS"][4],0],[Global.DG_Mods["CLASS"][5],0],\
										[Global.DG_Mods["GEAR_TYPE"][0],0],[Global.DG_Mods["GEAR_TYPE"][1],0],[Global.DG_Mods["GEAR_TYPE"][2],0]],
								"spec_feats":[[Global.DG_Mods["UNIQUE_ROOMS"][0],0],[Global.DG_Mods["UNIQUE_ROOMS"][0],0],\
									[Global.DG_Mods["BOSS"][0],0],[Global.DG_Mods["BOSS"][1],0],[Global.DG_Mods["BOSS"][2],0],[Global.DG_Mods["BOSS"][3],0],[Global.DG_Mods["BOSS"][4],0],[Global.DG_Mods["BOSS"][5],0],[Global.DG_Mods["BOSS"][6],0],[Global.DG_Mods["BOSS"][7],0],[Global.DG_Mods["BOSS"][8],0],[Global.DG_Mods["BOSS"][9],0],[Global.DG_Mods["BOSS"][10],0]]},
							"FIRE":
								{"ID": 1,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"WATER":
								{"ID": 2,
								"affinity":[[Global.DG_Mods["ELEMENTS"][1],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"EARTH":
								{"ID": 3,
								"affinity":[[Global.DG_Mods["ELEMENTS"][2],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"AIR":
								{"ID": 4,
								"affinity":[[Global.DG_Mods["ELEMENTS"][3],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"FORCE":
								{"ID": 5,
								"affinity":[[Global.DG_Mods["ELEMENTS"][4],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"VOLCANO":
								{"ID": 6,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],1]],
								"environ":[[Global.DG_Mods["BIOMES"][1],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"ISLANDS":
								{"ID": 7,
								"affinity":[[Global.DG_Mods["ELEMENTS"][1],1]],
								"environ":[[Global.DG_Mods["BIOMES"][2],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"MESA":
								{"ID": 8,
								"affinity":[[Global.DG_Mods["ELEMENTS"][2],1]],
								"environ":[[Global.DG_Mods["BIOMES"][3],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"SKY_ISLANDS":
								{"ID": 9,
								"affinity":[[Global.DG_Mods["ELEMENTS"][3],1]],
								"environ":[[Global.DG_Mods["BIOMES"][4],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"RIVER":
								{"ID": 10,
								"affinity":[],
								"environ":[[Global.DG_Mods["ENV_FEATURES"][0],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"LAKE":
								{"ID": 11,
								"affinity":[],
								"environ":[[Global.DG_Mods["ENV_FEATURES"][1],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"ROUND_ROOMS":
								{"ID": 12,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][0],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"DENSE_LAYOUT":
								{"ID": 13,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][1],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"SPARSE_LAYOUT":
								{"ID": 14,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][2],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"ALTERNATING_SIZE_ROOMS":
								{"ID": 15,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][3],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"SMALL_ROOMS":
								{"ID": 16,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][4],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"LARGE_ROOMS":
								{"ID": 17,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][5],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"CONSUMABLES":
								{"ID": 18,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][2],1]],
								"spec_feats":[]},
							"GEAR":
								{"ID": 19,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][3],1]],
								"spec_feats":[]},
							"LOCKBOXES":
								{"ID": 20,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][3],1]],
								"spec_feats":[]},
							"WEAPONS":
								{"ID": 21,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["GEAR_TYPE"][0],1]],
								"spec_feats":[]},
							"ARMOUR":
								{"ID": 22,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["GEAR_TYPE"][1],1]],
								"spec_feats":[]},
							"TRINKETS":
								{"ID": 23,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["GEAR_TYPE"][2],1]],
								"spec_feats":[]},
							"VANGUARD":
								{"ID": 24,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][0],1]],
								"spec_feats":[]},
							"WARRIOR":
								{"ID": 25,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][1],1]],
								"spec_feats":[]},
							"MAGE":
								{"ID": 26,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][2],1]],
								"spec_feats":[]},
							"ROGUE":
								{"ID": 27,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][3],1]],
								"spec_feats":[]},
							"HEALER":
								{"ID": 28,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][4],1]],
								"spec_feats":[]},
							"JESTER":
								{"ID": 29,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][5],1]],
								"spec_feats":[]},
							"INCREASED_MOB_DENSITY":
								{"ID": 30,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],10],[Global.DG_Mods["MOB_MODIFIERS"][1],-1]],
								"loot":[],
								"spec_feats":[]},
							"INCREASED_GOLD":
								{"ID": 31,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_MODIFIERS"][3],1]],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][0],1]],
								"spec_feats":[]},
							"INCREASED_XP":
								{"ID": 32,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],-1],[Global.DG_Mods["MOB_MODIFIERS"][2],2]],
								"loot":[],
								"spec_feats":[]},
							"DECREASED_MOB_DENSITY":
								{"ID": 33,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],-10],[Global.DG_Mods["MOB_MODIFIERS"][1],3]],
								"loot":[],
								"spec_feats":[]},
							"DECREASED_GOLD":
								{"ID": 34,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_MODIFIERS"][3],-1],[Global.DG_Mods["MOB_MODIFIERS"][4],1]],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][0],-1],[Global.DG_Mods["ITEM_TYPE"][2],0.4],[Global.DG_Mods["ITEM_TYPE"][3],0.4]],
								"spec_feats":[]},
							"DECREASED_XP":
								{"ID": 35,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][2],-2],[Global.DG_Mods["MOB_MODIFIERS"][3],1],[Global.DG_Mods["MOB_MODIFIERS"][4],1]],
								"loot":[],
								"spec_feats":[]},
							"BEASTS":
								{"ID": 36,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][0],1]],
								"loot":[],
								"spec_feats":[]},
							"ELEMENTALS":
								{"ID": 37,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][1],1]],
								"loot":[],
								"spec_feats":[]},
							"UNDEAD":
								{"ID": 38,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][2],1]],
								"loot":[],
								"spec_feats":[]},
							"CONSTRUCTS":
								{"ID": 39,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][3],1]],
								"loot":[],
								"spec_feats":[]},
							"MORTALS":
								{"ID": 40,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][4],1]],
								"loot":[],
								"spec_feats":[]},
							"WILDLINGS":
								{"ID": 41,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][5],1]],
								"loot":[],
								"spec_feats":[]},
							"TREASURE_ROOM":
								{"ID": 42,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["UNIQUE_ROOMS"][0],1]]},
							"MINI_BOSS":
								{"ID": 43,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][1],1]]},
							"MONSTER_HOUSE":
								{"ID": 44,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["UNIQUE_ROOMS"][1],1]]},
							"T1_BOSS":
								{"ID": 45,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][2],1]]},
							"T1_FIREBOSS":
								{"ID": 46,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][3],1]]},
							"T1_WATERBOSS":
								{"ID": 47,
								"affinity":[[Global.DG_Mods["ELEMENTS"][1],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][4],1]]},
							"T1_EARTHBOSS":
								{"ID": 48,
								"affinity":[[Global.DG_Mods["ELEMENTS"][2],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][5],1]]},
							"T1_AIRBOSS":
								{"ID": 49,
								"affinity":[[Global.DG_Mods["ELEMENTS"][3],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][6],1]]},
							"T1_FORCEBOSS":
								{"ID": 50,
								"affinity":[[Global.DG_Mods["ELEMENTS"][4],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][7],1]]},
							"T2_BOSS":
								{"ID": 51,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][8],1]]},
							"T2_QUADBOSS":
								{"ID": 52,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],1],[Global.DG_Mods["ELEMENTS"][1],1],[Global.DG_Mods["ELEMENTS"][2],1],[Global.DG_Mods["ELEMENTS"][3],1],],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][9],1]]},
							"T2_FORCEBOSS":
								{"ID": 53,
								"affinity":[[Global.DG_Mods["ELEMENTS"][4],4]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][10],1]]},
							}
