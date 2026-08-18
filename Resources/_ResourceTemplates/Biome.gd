extends Resource
class_name Biome

@export var BiomeID:BIOMES = 0

@export var Unique_Rooms:Array[Resource]
@export var Common_Enemies:Array[StatComponent]
@export var Rare_Enemies:Array[StatComponent]
@export var Common_Items:Array[ItemData]
@export var Rare_Items:Array[ItemData]

@export var Mini_Boss:StatComponent
@export var Wandering_Boss:bool = false
@export var Flooded:bool = false
@export var FloodTile:FLOOD_TILE
@export var RiverTile:RIVER_TILE
@export var RoomDensity:ROOM_DENSITY
@export var RoomSize:ROOM_SIZE
@export var RoundRooms:bool = false
#enum ELEMENTS {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum BIOMES{test,VOLCANO,ISLAND,MESA,SKY_ISLAND}
enum ENV_FEATURES{RIVER,LAKE,FLOODED,BARREN}
enum FLOOD_TILE{WATER,LAVA,AIR}
enum RIVER_TILE{WATER,LAVA,AIR}
enum ROOM_SIZE{ALTERNATING_SIZE_ROOMS,SMALL_ROOMS,LARGE_ROOMS}
enum ROOM_DENSITY{AVERAGE_LAYOUT,DENSE_LAYOUT,SPARSE_LAYOUT}
#enum GEAR_TYPE{WEAPON,ARMOUR,TRINKET}
#enum CLASS{VANGUARD,WARRIOR,MAGE,ROGUE,HEALER,JESTER}


func get_drop_pools(AreaLevel:int):
	Common_Items.clear()
	Rare_Items.clear()
	Common_Items.append(load("res://Resources/Items/Other/Gold.tres"))
	Rare_Items.append(load("res://Resources/Items/Other/Gold.tres"))
	var all_items = []
	var Items_Consumable:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Consumables.tres")
	var Items_Gear:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Gear.tres")
	var Items_Tiles:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Tiles.tres")
	var Items_Lockboxes:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Lockboxes.tres")
	Items_Consumable.load_all_into(all_items)
	Items_Gear.load_all_into(all_items)
	Items_Tiles.load_all_into(all_items)
	Items_Lockboxes.load_all_into(all_items)
	var filtered_items = []
	for item:ItemData in all_items:
		if not (item.min_area_level > AreaLevel or item.max_area_level < AreaLevel):
			filtered_items.append(item)
	all_items = filtered_items
	match BiomeID:
		0:
			for item:ItemData in all_items:
				if item.Affinity_Light or item.Affinity_Dark or item.Affinity_Force:
					if item.rarity < 2:
						Common_Items.append(item)
					else:
						Rare_Items.append(item)
		1:
			for item:ItemData in all_items:
				if item.Affinity_Fire or item.Affinity_Force:
					if item.rarity < 2:
						Common_Items.append(item)
					else:
						Rare_Items.append(item)
		2:
			for item:ItemData in all_items:
				if item.Affinity_Water or item.Affinity_Force:
					if item.rarity < 2:
						Common_Items.append(item)
					else:
						Rare_Items.append(item)
		3:
			for item:ItemData in all_items:
				if item.Affinity_Earth or item.Affinity_Force:
					if item.rarity < 2:
						Common_Items.append(item)
					else:
						Rare_Items.append(item)
		4:
			for item:ItemData in all_items:
				if item.Affinity_Air or item.Affinity_Force:
					if item.rarity < 2:
						Common_Items.append(item)
					else:
						Rare_Items.append(item)
	return [Common_Items,Rare_Items]


var mods = []

func get_DG_Mods():
	if mods.is_empty():
		match RoomDensity:
			0: #'its the default'
				pass
			1:
				mods.append([Global.DG_Mods["ROOMS"][1],4])
			2:
				mods.append([Global.DG_Mods["ROOMS"][2],4])
		match RoomSize:
			0:
				mods.append([Global.DG_Mods["ROOMS"][3],4])
			1:
				mods.append([Global.DG_Mods["ROOMS"][4],4])
			2:
				mods.append([Global.DG_Mods["ROOMS"][5],4])
		if RoundRooms:
			mods.append([Global.DG_Mods["ROOMS"][0],4])
		if Mini_Boss:
			mods.append([Global.DG_Mods["BOSS"][0],1])
		if Wandering_Boss:
			mods.append([Global.DG_Mods["BOSS"][2],1])
		if Flooded:
			mods.append([Global.DG_Mods["ENV_FEATURES"][2],4])
	return mods




#@export var RoomSize:Array[Roomsize]

#var Affinity = [[Global.DG_Mods["ELEMENTS"][0],0],[Global.DG_Mods["ELEMENTS"][1],0],[Global.DG_Mods["ELEMENTS"][2],0],[Global.DG_Mods["ELEMENTS"][3],0],[Global.DG_Mods["ELEMENTS"][4],0],[Global.DG_Mods["ELEMENTS"][5],0],[Global.DG_Mods["ELEMENTS"][6],0]]
#[[Global.ELEMENTS.FIRE,0],[Global.ELEMENTS.WATER,0],[Global.ELEMENTS.EARTH,0],[Global.ELEMENTS.AIR,0],[Global.ELEMENTS.FORCE,0],[Global.ELEMENTS.LIGHT,0],[Global.ELEMENTS.DARK,0]]
#var Environments:Array = [[Global.DG_Mods["BIOMES"][0],0],[Global.DG_Mods["BIOMES"][1],0],[Global.DG_Mods["BIOMES"][2],0],[Global.DG_Mods["BIOMES"][3],0],[Global.DG_Mods["BIOMES"][4],0],\
								#[[Global.BIOMES.TEST,0],[Global.BIOMES.VOLCANO,0],[Global.BIOMES.ISLAND,0],[Global.BIOMES.MESA,0],[Global.BIOMES.SKY_ISLAND,0],\
#								[Global.DG_Mods["ENV_FEATURES"][0],0],[Global.DG_Mods["ENV_FEATURES"][1],0],[Global.DG_Mods["ENV_FEATURES"][2],0],[Global.DG_Mods["ENV_FEATURES"][3],0],\
								#[Global.ENV_FEATURES.RIVER,0],[Global.ENV_FEATURES.LAKE,0],[Global.ENV_FEATURES.FLOODED,0],\
#								[Global.DG_Mods["ROOMS"][0],0],[Global.DG_Mods["ROOMS"][1],0],[Global.DG_Mods["ROOMS"][2],0],[Global.DG_Mods["ROOMS"][3],0],[Global.DG_Mods["ROOMS"][4],0],[Global.DG_Mods["ROOMS"][5],0]]
								#[Global.ROOMS.ROUND,0],[Global.ROOMS.DENSE,0],[Global.ROOMS.SPARSE,0],[Global.ROOMS.ALTERNATING_SIZE,0],[Global.ROOMS.SMALL,0],[Global.ROOMS.LARGE,0]]
#var Enemies:Array = [[Global.DG_Mods["MOB_MODIFIERS"][0],0],[Global.DG_Mods["MOB_MODIFIERS"][1],0],[Global.DG_Mods["MOB_MODIFIERS"][2],0],[Global.DG_Mods["MOB_MODIFIERS"][3],0],[Global.DG_Mods["MOB_MODIFIERS"][4],0],\
#							[Global.DG_Mods["MOB_TYPE"][0],0],[Global.DG_Mods["MOB_TYPE"][1],0],[Global.DG_Mods["MOB_TYPE"][2],0],[Global.DG_Mods["MOB_TYPE"][3],0],[Global.DG_Mods["MOB_TYPE"][4],0],[Global.DG_Mods["MOB_TYPE"][5],0]]
#= [[Global.SPAWN_RATE.MOBS,0],[Global.MOB_TYPE.BEAST,0],[Global.MOB_TYPE.ELEMENTAL,0],[Global.MOB_TYPE.UNDEAD,0],[Global.MOB_TYPE.CONSTRUCT,0],[Global.MOB_TYPE.MORTAL,0],[Global.MOB_TYPE.WILDLING,0],\
#	[Global.MOB_MODIFIERS.LEVEL,0],[Global.MOB_MODIFIERS.EXP,0],[Global.MOB_MODIFIERS.GOLD,0]]
#var Loot:Array = [[Global.DG_Mods["ITEM_MODIFIERS"][0],0],[Global.DG_Mods["ITEM_TYPE"][0],0],[Global.DG_Mods["ITEM_TYPE"][1],0],[Global.DG_Mods["ITEM_TYPE"][2],0],[Global.DG_Mods["ITEM_TYPE"][3],0],[Global.DG_Mods["ITEM_TYPE"][4],0],[Global.DG_Mods["ITEM_TYPE"][5],0],\
						#= [[Global.SPAWN_RATE.GOLD,0],[Global.SPAWN_RATE.ITEMS,0],[Global.ITEM_TYPE.GOLD,0],[Global.ITEM_TYPE.CONSUMABLE,0],[Global.ITEM_TYPE.GEAR,0],[Global.ITEM_TYPE.LOCKBOXES,0],\
#						[Global.DG_Mods["CLASS"][0],0],[Global.DG_Mods["CLASS"][1],0],[Global.DG_Mods["CLASS"][2],0],[Global.DG_Mods["CLASS"][3],0],[Global.DG_Mods["CLASS"][4],0],[Global.DG_Mods["CLASS"][5],0],\
						#[Global.CLASS.VANGUARD,0],[Global.CLASS.WARRIOR,0],[Global.CLASS.MAGE,0],[Global.CLASS.ROGUE,0],[Global.CLASS.HEALER,0],[Global.CLASS.JESTER,0],\
#						[Global.DG_Mods["GEAR_TYPE"][0],0],[Global.DG_Mods["GEAR_TYPE"][1],0],[Global.DG_Mods["GEAR_TYPE"][2],0]]
						#[Global.GEAR_TYPE.WEAPON,0],[Global.GEAR_TYPE.ARMOUR,0],[Global.GEAR_TYPE.TRINKET,0]]
#var Special_Features:Array = [[Global.DG_Mods["UNIQUE_ROOMS"][0],0],[Global.DG_Mods["UNIQUE_ROOMS"][1],0],\
#									[Global.DG_Mods["BOSS"][0],0],[Global.DG_Mods["BOSS"][1],0],[Global.DG_Mods["BOSS"][2],0],[Global.DG_Mods["BOSS"][3],0],[Global.DG_Mods["BOSS"][4],0],[Global.DG_Mods["BOSS"][5],0],[Global.DG_Mods["BOSS"][6],0],[Global.DG_Mods["BOSS"][7],0],[Global.DG_Mods["BOSS"][8],0],[Global.DG_Mods["BOSS"][9],0],[Global.DG_Mods["BOSS"][10],0]]
									#"T0_ROAMING","T0_MINI","T1_BOSS","T1_FIREBOSS","T1_WATERBOSS","T1_EARTHBOSS","T1_WINDBOSS","T1_FORCEBOSS","T2_BOSS","T2_QUADBOSS","T2_FORCEBOSS"
