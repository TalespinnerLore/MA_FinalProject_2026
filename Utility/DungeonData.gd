extends Node

@export_category("DungeonGen")
@export var Affinity = [[Global.DG_Mods["ELEMENTS"][0],0],[Global.DG_Mods["ELEMENTS"][1],0],[Global.DG_Mods["ELEMENTS"][2],0],[Global.DG_Mods["ELEMENTS"][3],0],[Global.DG_Mods["ELEMENTS"][4],0],[Global.DG_Mods["ELEMENTS"][5],0],[Global.DG_Mods["ELEMENTS"][6],0]]
#[[Global.ELEMENTS.FIRE,0],[Global.ELEMENTS.WATER,0],[Global.ELEMENTS.EARTH,0],[Global.ELEMENTS.AIR,0],[Global.ELEMENTS.FORCE,0],[Global.ELEMENTS.LIGHT,0],[Global.ELEMENTS.DARK,0]]
@export var Environments:Array = [[Global.DG_Mods["BIOMES"][0],0],[Global.DG_Mods["BIOMES"][1],0],[Global.DG_Mods["BIOMES"][2],0],[Global.DG_Mods["BIOMES"][3],0],[Global.DG_Mods["BIOMES"][4],0],\
								[Global.DG_Mods["ENV_FEATURES"][0],0],[Global.DG_Mods["ENV_FEATURES"][1],0],[Global.DG_Mods["ENV_FEATURES"][2],0],[Global.DG_Mods["ENV_FEATURES"][3],0],\
								[Global.DG_Mods["ROOMS"][0],0],[Global.DG_Mods["ROOMS"][1],0],[Global.DG_Mods["ROOMS"][2],0],[Global.DG_Mods["ROOMS"][3],0],[Global.DG_Mods["ROOMS"][4],0],[Global.DG_Mods["ROOMS"][5],0]]
#= [[Global.BIOMES.TEST,0],[Global.BIOMES.VOLCANO,0],[Global.BIOMES.ISLAND,0],[Global.BIOMES.MESA,0],[Global.BIOMES.SKY_ISLAND,0],\
#	[Global.ENV_FEATURES.RIVER,0],[Global.ENV_FEATURES.LAKE,0],[Global.ENV_FEATURES.FLOODED,0],\
#	[Global.ROOMS.ROUND,0],[Global.ROOMS.DENSE,0],[Global.ROOMS.SPARSE,0],[Global.ROOMS.ALTERNATING_SIZE,0],[Global.ROOMS.SMALL,0],[Global.ROOMS.LARGE,0]]
#	[Global.ENV_FEATURES.RIVER,0],[Global.ENV_FEATURES.LAKE,0],[Global.ENV_FEATURES.FLOODED,0],\
#	[Global.ROOMS.ROUND,0],[Global.ROOMS.DENSE,0],[Global.ROOMS.SPARSE,0],[Global.ROOMS.ALTERNATING_SIZE,0],[Global.ROOMS.SMALL,0],[Global.ROOMS.LARGE,0]]
@export var Enemies:Array = [[Global.DG_Mods["MOB_MODIFIERS"][0],0],[Global.DG_Mods["MOB_MODIFIERS"][1],0],[Global.DG_Mods["MOB_MODIFIERS"][2],0],[Global.DG_Mods["MOB_MODIFIERS"][3],0],[Global.DG_Mods["MOB_MODIFIERS"][4],0],\
							[Global.DG_Mods["MOB_TYPE"][0],0],[Global.DG_Mods["MOB_TYPE"][1],0],[Global.DG_Mods["MOB_TYPE"][2],0],[Global.DG_Mods["MOB_TYPE"][3],0],[Global.DG_Mods["MOB_TYPE"][4],0],[Global.DG_Mods["MOB_TYPE"][5],0]]
#= [[Global.SPAWN_RATE.MOBS,0],[Global.MOB_TYPE.BEAST,0],[Global.MOB_TYPE.ELEMENTAL,0],[Global.MOB_TYPE.UNDEAD,0],[Global.MOB_TYPE.CONSTRUCT,0],[Global.MOB_TYPE.MORTAL,0],[Global.MOB_TYPE.WILDLING,0],\
#	[Global.MOB_MODIFIERS.LEVEL,0],[Global.MOB_MODIFIERS.EXP,0],[Global.MOB_MODIFIERS.GOLD,0]]
@export var Loot:Array = [[Global.DG_Mods["ITEM_MODIFIERS"][0],0],[Global.DG_Mods["ITEM_TYPE"][0],0],[Global.DG_Mods["ITEM_TYPE"][1],0],[Global.DG_Mods["ITEM_TYPE"][2],0],[Global.DG_Mods["ITEM_TYPE"][3],0],[Global.DG_Mods["ITEM_TYPE"][4],0],[Global.DG_Mods["ITEM_TYPE"][5],0],\
						[Global.DG_Mods["CLASS"][0],0],[Global.DG_Mods["CLASS"][1],0],[Global.DG_Mods["CLASS"][2],0],[Global.DG_Mods["CLASS"][3],0],[Global.DG_Mods["CLASS"][4],0],[Global.DG_Mods["CLASS"][5],0],\
						[Global.DG_Mods["GEAR_TYPE"][0],0],[Global.DG_Mods["GEAR_TYPE"][1],0],[Global.DG_Mods["GEAR_TYPE"][2],0]]
#= [[Global.SPAWN_RATE.GOLD,0],[Global.SPAWN_RATE.ITEMS,0],[Global.ITEM_TYPE.GOLD,0],[Global.ITEM_TYPE.CONSUMABLE,0],[Global.ITEM_TYPE.GEAR,0],[Global.ITEM_TYPE.LOCKBOXES,0],\
#	[Global.CLASS.VANGUARD,0],[Global.CLASS.WARRIOR,0],[Global.CLASS.MAGE,0],[Global.CLASS.ROGUE,0],[Global.CLASS.HEALER,0],[Global.CLASS.JESTER,0],\
#	[Global.GEAR_TYPE.WEAPON,0],[Global.GEAR_TYPE.ARMOUR,0],[Global.GEAR_TYPE.TRINKET,0]]
@export var Special_Features:Array = [[Global.DG_Mods["UNIQUE_ROOMS"][0],0],[Global.DG_Mods["UNIQUE_ROOMS"][1],0],\
									[Global.DG_Mods["BOSS"][0],0],[Global.DG_Mods["BOSS"][1],0],[Global.DG_Mods["BOSS"][2],0],[Global.DG_Mods["BOSS"][3],0],[Global.DG_Mods["BOSS"][4],0],[Global.DG_Mods["BOSS"][5],0],[Global.DG_Mods["BOSS"][6],0],[Global.DG_Mods["BOSS"][7],0],[Global.DG_Mods["BOSS"][8],0],[Global.DG_Mods["BOSS"][9],0],[Global.DG_Mods["BOSS"][10],0]]
#"T0_ROAMING","T0_MINI","T1_BOSS","T1_FIREBOSS","T1_WATERBOSS","T1_EARTHBOSS","T1_WINDBOSS","T1_FORCEBOSS","T2_BOSS","T2_QUADBOSS","T2_FORCEBOSS"

var biomes:Array[Biome] = [preload("res://Resources/DungeonGen/Biome_Volcano.tres"),
			preload("res://Resources/DungeonGen/Biome_Volcano.tres"),
			preload("res://Resources/DungeonGen/Biome_Island.tres"),
			preload("res://Resources/DungeonGen/Biome_Mesa.tres"),
			preload("res://Resources/DungeonGen/Biome_SkyIsland.tres")]

var floor_biome:Biome = biomes[4]

func choose_biome():
	var total_chance = Environments[0][1] + Environments[1][1] + Environments[2][1] + Environments[3][1] + Environments[4][1]
	if total_chance <= 4:
		total_chance = 4
	else:
		total_chance += 1
	
	var randint = randi_range(0,total_chance)
	
	if randint >= total_chance - Environments[4][1] and  Environments[4][1] != 0:
		return 4 #SKY_ISLAND
	if randint >= total_chance - Environments[3][1] and  Environments[3][1] != 0:
		return 3 #MESA
	if randint >= total_chance - Environments[2][1] and  Environments[2][1] != 0:
		return 2 #ISLAND
	if randint >= total_chance - Environments[1][1] and  Environments[1][1] != 0:
		return 1 #VOLCANO
	if randint >= total_chance - Environments[0][1] and  Environments[0][1] != 0:
		return 0 #TEST
	return randi_range(1,4) #SELECT RANDOM BIOME
	

var room_attempts = 25
var interconnectivity = 2#0-10 range
var rounded = false
var spawn_river = false
var flooded:bool = false
var max_size = 15
var min_size = 5


func open_level():
	floor_biome = biomes[choose_biome()]
	var biome_mods = floor_biome.get_DG_Mods()
	for mod in biome_mods:
		for entry in Affinity:
			if entry[0] == mod[0]:
				entry[1]+=mod[1]
		for entry in Enemies:
			if entry[0] == mod[0]:
				entry[1]+=mod[1]
		for entry in Environments:
			if entry[0] == mod[0]:
				entry[1]+=mod[1]
		for entry in Loot:
			if entry[0] == mod[0]:
				entry[1]+=mod[1]
		for entry in Special_Features:
			if entry[0] == mod[0]:
				entry[1]+=mod[1]
	
	if Environments[5][1] > randi_range(0,4):
		spawn_river = true
	else:
		spawn_river = false
	
	if Environments[7][1] >= randi_range(0,4):
		flooded = true
	else:
		flooded = false
	
	
	if Environments[9][1]  >= randi_range(0,4):
		rounded = true
	else:
		rounded = false
	
	if (Environments[10][1] > randi_range(0,4)) and (Environments[11][1] <= randi_range(0,4)) :
		room_attempts = 50
	elif Environments[11][1] > randi_range(0,4) and Environments[10][1] <= randi_range(0,4):
		room_attempts = 15
	else:
		room_attempts = 25
	
	if Environments[14][1] > randi_range(0,4):
		var max_size = 20
		var min_size = 10
	if Environments[13][1] > randi_range(0,4):
		var max_size = 10
		var min_size = 5
	if Environments[12][1] > randi_range(0,4):
		var max_size = 15
		var min_size = 5
	
	get_tree().change_scene_to_file("res://Scenes/DungeonGen/testingshit_FLOORSPAWNING.tscn")
	pass
	
