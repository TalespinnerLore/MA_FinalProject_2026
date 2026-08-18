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

var biomes:Array[Biome] = [preload("res://Resources/DungeonGen/Biome_Test.tres"),
			preload("res://Resources/DungeonGen/Biome_Volcano.tres"),
			preload("res://Resources/DungeonGen/Biome_Island.tres"),
			preload("res://Resources/DungeonGen/Biome_Mesa.tres"),
			preload("res://Resources/DungeonGen/Biome_SkyIsland.tres")]



###vvvDEPRECIATEDvvv###
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


var floor_biome:Biome = biomes[3]
@export var Common_Enemies:Array[StatComponent]
@export var Rare_Enemies:Array[StatComponent]
@export var Common_Items:Array[ItemData]
@export var Rare_Items:Array[ItemData]
@export var Unique_Rooms:Array[UniqueRoomData]

var room_attempts = 25
var interconnectivity = 4.0#0-10 range7
var rounded = false
var spawn_river =  false
var flooded:bool = false
var river_tile = 'WATER'
var flood_tile = 'WATER'
var max_size = 15
var min_size = 5
var level_size:=Vector2i(30,30)


var max_wandering_units := 5

var max_floors: = 5
var current_floor: = 0
var monster_house_count: = 1

var AREA_LEVEL := 1
var UNIT_LEVEL_Boost := 0

var floor_is_monsterhouse := false

var item_mult = 1.0
var gold_chance = 2.0
var tile_chance = 1.5
var cons_chance = 2.0
var gear_chance = 1.0
var lockbox_chance = 0.5

var pot_chance = 1.0


var current_biome

var minibossdata:StatComponent = preload("res://Resources/Units/Enemy/MiniBoss.tres")

var room_chance = 1.0
###vvvDEPRECIATEDvvv###
func spawn_unique_room_chance(remaining:int,roomdata:UniqueRoomData):
	var added = 0
	if current_floor == max_floors - 1:
		for i in remaining:
			Unique_Rooms.append(roomdata)
			added+=1
	else:
		var spread = floori((max_floors-1) / remaining)
		var roll = randi_range(1,spread)
		if roll == 1:
			Unique_Rooms.append(roomdata)
			added+=1
	return added

func save_player_data():
	var p1 = get_tree().get_first_node_in_group("Player")
	PlayerStats.p1_ability_usesB1234WAT = p1.ABILITIES.ability_usesB1234WAT
	PlayerStats.p1_HP = p1.HP_Current
	PlayerStats.p1_XP = p1.XP


###vvvDEPRECIATEDvvv###
func open_level():
	current_floor += 1
	set_river_and_flood_tiles()
	if current_floor == 1:
		monster_house_count = Special_Features[1][1]
		for i in range(8):
			PlayerStats.fill_ability_usesB1234WAT(0,i)
	else:
		pass
	
	
	UNIT_LEVEL_Boost = Enemies[0][1]
	
	if Special_Features[0][1] > 0:
		var spawned = spawn_unique_room_chance(Special_Features[0][1],load("res://Resources/DungeonGen/UniqueRooms/Resources/TREASURE_ROOM.tres"))
		Special_Features[0][1] -= spawned
	if Special_Features[3][1] > 0:
		var spawned = spawn_unique_room_chance(Special_Features[3][1],load("res://Resources/DungeonGen/UniqueRooms/Resources/MINI_BOSS.tres"))
		Special_Features[3][1] -= spawned
	
	if current_floor == max_floors: #temp monster house w/mini boss as final floor
		monster_house_count = 1
		max_wandering_units = 1

	floor_biome = biomes[choose_biome()]
	current_biome = floor_biome#
	var biome_mods = floor_biome.get_DG_Mods()
	Common_Enemies = floor_biome.Common_Enemies
	Rare_Enemies = floor_biome.Rare_Enemies
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
	
	gold_chance += (0.25*Loot[0][1])
	pot_chance += (0.25*Loot[2][1])
	item_mult += (0.05*Loot[1][1])
	
	get_tree().change_scene_to_file("res://Scenes/DungeonGen/DungeonSceneStructure.tscn")
	pass	

###vvvDEPRECIATEDvvv###
func dungeon_gen_testing():
	floor_biome = biomes[choose_biome()]
	var biome_mods = floor_biome.get_DG_Mods()
	Common_Enemies = floor_biome.Common_Enemies
	Rare_Enemies = floor_biome.Rare_Enemies
	max_wandering_units = ((level_size.x + level_size.y) / 10) - 1
	set_river_and_flood_tiles()
	if current_floor == max_floors:
		monster_house_count = 1
		max_wandering_units = 1
		Common_Enemies.clear()
		Rare_Enemies.clear()
		Common_Enemies.append(load("res://Resources/Units/Enemy/MiniBoss.tres"))
		Rare_Enemies.append(load("res://Resources/Units/Enemy/MiniBoss.tres"))






















func reset_data():
	current_floor = 0
	item_mult = 1.0
	gold_chance = 2.5
	tile_chance = 1.5
	cons_chance = 2.0
	gear_chance = 1.0
	lockbox_chance = 0.5

	safe_floors.clear()
	floors_special_features.clear()
	final_floor = 0
	PRESET_Recipie = false
	final_floor_layout = null
	safe_room_floor_layout = null
	boss = null
	mini_bosses.clear()

	Affinity_Fire = 0
	Affinity_Water = 0
	Affinity_Earth = 0
	Affinity_Air = 0
	Affinity_Force = 0
	Affinity_Light = 0
	Affinity_Dark = 0
	Biome_Test = 0
	Biome_Volcano = 0
	Biome_Island = 0
	Biome_Mesa = 0
	Biome_Skyland = 0
	EnvFeature_River = 0
	EnvFeature_Lake = 0
	EnvFeature_Flooded = 0
	EnvFeature_Barren = 0
	Rooms_Round = 0
	Rooms_DenseLayout = 0
	Rooms_SparceLayout = 0
	Rooms_AlternatingSize = 0
	Rooms_Small = 0
	Rooms_Large = 0
	ItemType_Gold = 0
	ItemType_Tiles = 0
	ItemType_Consumable = 0
	ItemType_Gear = 0
	ItemType_Lockboxes = 0
	ItemType_KeyItem = 0
	ItemMods_SpawnRate = 0
	GearType_Weapon = 0
	GearType_Armour = 0
	GearType_Trinket = 0
	Class_Vanguard = 0
	Class_Warrior = 0
	Class_Mage = 0
	Class_Rogue = 0
	Class_Healer = 0
	Class_Jester = 0
	MobType_Beast = 0
	MobType_Elemental = 0
	MobType_Undead = 0
	MobType_Construct = 0
	MobType_Mortal = 0
	MobType_Wildling = 0
	MobMods_SpawnRate = 0
	MobMods_Level = 0
	MobMods_EXP = 0
	MobMods_Gold = 0
	MobMods_Gear = 0
	UniqueRooms_TreasureVault = 0
	UniqueRooms_MonsterHouse = 0
	Boss_T0_Roaming = 0
	Boss_T0_Mini = 0
	Boss_T1_Generic = 0
	Boss_T1_Fire = 0
	Boss_T1_Water = 0
	Boss_T1_Earth = 0
	Boss_T1_Wind = 0
	Boss_T1_Force = 0
	Boss_T2_Generic = 0
	Boss_T2_QuadElement = 0
	Boss_T2_Force = 0

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

enum FINAL_FLOOR {N_A,MON_HOUSE,MINI_BOSS,BOSS}
var final_floor_layout:UniqueRoomData
var safe_room_floor_layout:UniqueRoomData
var boss:StatComponent
var mini_bosses:Array[StatComponent]
var elites = Boss_T0_Roaming
var minis = Boss_T0_Mini
var houses = UniqueRooms_MonsterHouse
var vaults = UniqueRooms_TreasureVault
@export var safe_floors:Array[int] = []
@export var floors_special_features = []
@export var final_floor:FINAL_FLOOR = FINAL_FLOOR.N_A
@export var PRESET_Recipie := false

@export var crafting_tier:= 1



func open_level_new():
	print("old floor ",current_floor)
	current_floor += 1
	if current_floor < 1:
		current_floor = 1
	
	set_floor_data()
	#print("printtest openlevelnew:")
	#for i in Common_Enemies:
	#	print("printtest ",i.UnitName)
	get_tree().change_scene_to_file("res://Scenes/DungeonGen/DungeonSceneStructure.tscn")
	# init tilemap, wait, set playerdata, init unit infrastructure. 
	await get_tree().create_timer(0.2).timeout
	var tilemap_ref:Dungeon_Floor = get_tree().get_first_node_in_group("TILEMAP")
	tilemap_ref.init_tilemap()

func set_floor_data():
	##if floor 1, determine max floors, checkpoint floors, floor number for unique rooms,
	###floor num for key items, set player data
	#dungeon level/size, set biome, set biome preset data, set liquid tiles, river/flood
	#check if safe floor/checkpoint, unique rooms, room data/size/shape, load mob+item data,
	#vvv for different function vvv#
	#load new level scene, init tilemap, wait, set playerdata, init unit infrastructure. 
	if current_floor == 1:
		for i in range(0,8):
			PlayerStats.fill_ability_usesB1234WAT(0,i)
		if final_floor_layout == null:
			final_floor_layout = load("res://Resources/DungeonGen/UniqueRooms/Resources/FINAL_FLOOR_Generic.tres")
		if safe_room_floor_layout == null:
			safe_room_floor_layout = load("res://Resources/DungeonGen/UniqueRooms/Resources/SAFE_FLOOR_Generic.tres")
		#DETERMINE MAX FLOORS
		var safe_floor_amount = 0
		match crafting_tier:
			0:
				max_floors = 4 + extra_floors
				max_wandering_units = 2#4
			1:
				max_floors = 8 + extra_floors
				max_wandering_units = 6
				#safe_floor_amount = 1
			2:
				max_floors = 16 + extra_floors
				max_wandering_units = 8
				if has_boss:
					safe_floor_amount = 1
			3:
				max_floors = 24 + extra_floors
				max_wandering_units = 10
				safe_floor_amount = 1
			4:
				max_floors = 36 + extra_floors
				max_wandering_units = 12
				
				safe_floor_amount = 2
			5:
				max_floors = 40 + extra_floors
				max_wandering_units = 14
				safe_floor_amount = randi_range(0,2)
		
		max_wandering_units = floori(max_wandering_units*(100+MobMods_SpawnRate)/100)
		
		var safe_floor_step = 0
		if safe_floor_amount > 0:
			print("crafttier:",crafting_tier, " max-1:",max_floors-1," sflrs+1:",safe_floor_amount+1," step:",roundi(float(max_floors-1) / float(safe_floor_amount+1)))
			safe_floor_step = roundi(float(max_floors-1) / float(safe_floor_amount+1))
			print("sflrs:",safe_floor_amount," step:",roundi(max_floors-1 / safe_floor_amount+1),"floored:",floori(max_floors-1 / safe_floor_amount+1))
		#determine safe floors
		#floor num for unique rooms, and other special features
		
		elites = Boss_T0_Roaming
		minis = Boss_T0_Mini
		houses = UniqueRooms_MonsterHouse
		vaults = UniqueRooms_TreasureVault
		
		if randf() <= 0.05:
			houses+=1
		if randf() <= 0.025:
			vaults+=1
				
		if has_boss:
			final_floor = FINAL_FLOOR.BOSS
		elif Boss_T0_Mini > 0:
			final_floor = FINAL_FLOOR.MINI_BOSS
			minis -= 1
		elif UniqueRooms_MonsterHouse > 0:
			final_floor = FINAL_FLOOR.MON_HOUSE
			houses -= 1
		
		var echance = randf()
		var hchance = randf()
		var vchance = randf()
	
		if hchance <= 0.015*crafting_tier:
			houses+=1
		for i in randi_range(0,max_floors/4):
			if echance <= -1: #0.1: #-1 is becuase elites not properly implemented yet.
				elites+=1
			echance = randf()
		
		for i in range(1,max_floors):
			if safe_floor_amount > 0:
				if i%safe_floor_step == 0 and safe_floors.size() < safe_floor_amount:
					safe_floors.append(i)
			if i == max_floors - 2:
				if Boss_T2_Generic > 0 or Boss_T2_QuadElement > 0 or Boss_T2_Force > 0:
					safe_floors.append(i)
			floors_special_features.append([])
		
		for i in range(floors_special_features.size(),0,-1): #minibosses prioritize being befroe safe floors
			if safe_floors.has(i) and minis > 1:
				floors_special_features[i-1].append('MINI_BOSS')
				minis-=1
		floors_special_features.insert(0,['FLOOR 0 / NULL FLOOR']) #adds an empty value as index==0, so I can get matching index and floornum
		
		print("specfeat floor poss:",floors_special_features.size()-1)
		var floors_left = floors_special_features.size()
		
		for floor_index in range(1,floors_special_features.size()):
			floors_special_features[floor_index].append(str('FLOOR ',floor_index))
			var floor_count = max_floors-1-safe_floors.size()-(floor_index-1)
			#max_floors - final floor - num safe floors - num floors distributed to already.
			#print("floorindex:",floor_index)
			#print("possible floors total to distribute on:",floor)
			#the number of floors it's possible to stick a feature in remaining
			if ! safe_floors.has(floor_index) and floor_index != (max_floors) and floor_count > 0:
				print("echance",echance," count",floor_count," max",max_floors," flrindex",floor_index," safeflrs",safe_floors)
				if minis > 0 and ! floors_special_features[floor_index].has('MINI_BOSS') and\
				randf() <= float(minis/floor_count) :
					floors_special_features[floor_index].append('MINI_BOSS')
					minis-=1
				
				echance = float(elites/floor_count)
				if elites > 0 and randf() <= echance:
					floors_special_features[floor_index].append('ROAMING_ELITE')
					elites-=1
				hchance = float(houses/floor_count)
				if houses > 0 and randf() <= hchance:
					floors_special_features[floor_index].append('MONSTER_HOUSE')
					houses-=1
				vchance = float(vaults/floor_count)
				if vaults > 0 and randf() <= vchance:
					#if floors_special_features[floor_index].has('MONSTER_HOUSE'):
					#	pass#floors_special_features[floor_index-] FIX THIS
						##spawn a shitload of extra loot in the monster house instaead.
						##do this on timemap side.
					floors_special_features[floor_index].append('TREASURE_VAULT')
					vaults-=1
				#floors_left -= 1
			elif safe_floors.has(floor_index):
				floors_special_features[floor_index].append('SAFE')
		print('FLOOR FEATURES:',floors_special_features)
		
		gold_chance *= ItemType_Gold
		tile_chance *= ItemType_Tiles
		cons_chance *= ItemType_Consumable
		gear_chance *= MobMods_Gear
		lockbox_chance *= ItemType_Lockboxes
	else:
		pass#save_player_data()
	###CODE RUN FOR ALL FLOORS BELOW THIS LINE###
	level_size = Vector2i(25,25) + (clampi(int(current_floor/4),0,10)*Vector2i(4,4))
	
	#set biome, set biome preset data, set liquid tiles, river/flood
	floor_biome = biomes[select_biome_index()]
	if mini_bosses.size() < 1:
		mini_bosses.append(floor_biome.Mini_Boss)
	flooded = floor_biome.Flooded
	if EnvFeature_Lake > 0: #CHANGING THIS TO SWAP FLOODED STATE
		var reverse_chance = EnvFeature_Lake
		if EnvFeature_Lake <= randi_range(0,100):
			flooded = ! flooded #swap flooded state
	if EnvFeature_River+randi_range(0,25) <= randi_range(0,100): #always some chance of river spawning
		spawn_river = true
	set_river_and_flood_tiles()
	#unique rooms, room data/size/shape,
	
	var temp_item_mult = 1.0
	
	Unique_Rooms.clear()
	if floors_special_features[current_floor-1].has('MONSTER_HOUSE'):
		spawn_river = false
		floor_is_monsterhouse
	if floors_special_features[current_floor-1].has('TREASURE_VAULT'):
		if ! floors_special_features[current_floor-1].has('MONSTER_HOUSE'):
			Unique_Rooms.append(load("res://Resources/DungeonGen/UniqueRooms/Resources/TREASURE_ROOM.tres"))
		else:
			temp_item_mult += 5.0
	if floors_special_features[current_floor-1].has('MINI_BOSS'):	
		if ! floors_special_features[current_floor-1].has('MONSTER_HOUSE') and current_floor != max_floors:	
			Unique_Rooms.append(load("res://Resources/DungeonGen/UniqueRooms/Resources/MINI_BOSS.tres"))	
		else:
			temp_item_mult += 0.5
	
	if ! floor_biome.RoundRooms and randi_range(0,100) <= Rooms_Round:
		rounded = true
	elif floor_biome.RoundRooms and randi_range(0,100) <= Rooms_AlternatingSize:
		rounded = false#changing to square rooms, not alt size
	else:
		rounded = floor_biome.RoundRooms
	
	if randi_range(0,100) <= Rooms_Large and Rooms_Large > 0:
		max_size = 20
		min_size = 9
	elif randi_range(0,100) <= Rooms_Small and Rooms_Small > 0:
		max_size = 9
		min_size = 5
	else:
		match floor_biome.RoomSize:
			Biome.ROOM_SIZE.ALTERNATING_SIZE_ROOMS:
				max_size = 15
				min_size = 5
			Biome.ROOM_SIZE.SMALL_ROOMS:
				max_size = 9
				min_size = 5
			Biome.ROOM_SIZE.LARGE_ROOMS:
				max_size = 20
				min_size = 9
	
	if randi_range(0,100) <= Rooms_DenseLayout and Rooms_DenseLayout > 0:
		interconnectivity = (100+Rooms_DenseLayout) / 100 * 4.0
		room_attempts = (100+Rooms_DenseLayout) / 100  * 25
	elif randi_range(0,100) <= Rooms_SparceLayout and Rooms_SparceLayout > 0:
		interconnectivity = 4.0 / ((100+Rooms_SparceLayout)/100)
		room_attempts = 25 / ((100+Rooms_SparceLayout)/100)
	else:
		match floor_biome.RoomDensity:
			Biome.ROOM_DENSITY.AVERAGE_LAYOUT:
				interconnectivity = 4.0
				room_attempts = 25
			Biome.ROOM_DENSITY.DENSE_LAYOUT:
				interconnectivity = 8.0
				room_attempts = 50
			Biome.ROOM_DENSITY.SPARSE_LAYOUT:
				interconnectivity = 2.0
				room_attempts = 13
	#load mob+item data
	set_enemy_spawn_pool()
	
	UNIT_LEVEL_Boost = MobMods_Level
	
	set_item_spawn_pool() #write this - doneish ##do loot affecting tiles next
	
	item_mult = (1.0 + ItemMods_SpawnRate*0.01)*temp_item_mult
	
	if current_floor == max_floors:
		Unique_Rooms.append(final_floor_layout)
		var check = final_floor_layout.get_tiles()
		var check2:TileMapLayer = load(check).instantiate()
		level_size = check2.get_used_rect().size
		check2.queue_free()
		match final_floor:
			FINAL_FLOOR.N_A:
				max_wandering_units = 0
			FINAL_FLOOR.MON_HOUSE:
				max_wandering_units = int(max_wandering_units*1.25)
			FINAL_FLOOR.MINI_BOSS:
				print("unit name of mini boss",mini_bosses[0].UnitName)
				max_wandering_units = 1
				boss = mini_bosses[0]
				mini_bosses.pop_front()
			FINAL_FLOOR.BOSS:
				max_wandering_units = 1
	
	elif safe_floors.has(current_floor):
		Unique_Rooms.append(safe_room_floor_layout)
		var check = safe_room_floor_layout.get_tiles()
		var check2:TileMapLayer = load(check).instantiate()
		level_size = check2.get_used_rect().size
		check2.queue_free()
		print('safe floor tiles transferred')
	pass

func select_biome_index():
	var total_chance = Biome_Test + Biome_Volcano + Biome_Island + Biome_Mesa + Biome_Skyland
	if total_chance <= 100:
		total_chance = 100
	elif ! PRESET_Recipie:
		total_chance += 25 #always at least a 25% chance to get a random biome, unless boss tower.
	
	var randint = randi_range(0,total_chance)
	
	if randint >= total_chance - Biome_Skyland and Biome_Skyland != 0:
		return 4 #SKY_ISLAND
	if randint >= total_chance - Biome_Mesa and Biome_Mesa != 0:
		return 3 #MESA
	if randint >= total_chance - Biome_Island and Biome_Island != 0:
		return 2 #ISLAND
	if randint >= total_chance - Biome_Volcano and Biome_Volcano != 0:
		return 1 #VOLCANO
	if randint >= total_chance - Biome_Test and Biome_Test != 0:
		return 0 #TEST
	return randi_range(1,4) #SELECT RANDOM BIOME

func set_river_and_flood_tiles():
	var rivertile_chance = Affinity_Fire+Affinity_Water+Affinity_Air
	var randint = randi_range(0,rivertile_chance+100)
	match floor_biome.RiverTile:
		floor_biome.RIVER_TILE.WATER:
			if randint >= rivertile_chance - Affinity_Water - 100:
				river_tile = 'WATER'
			elif randint >= rivertile_chance - Affinity_Fire - 100 - Affinity_Water:
				river_tile = 'LAVA'
			else:
				river_tile = 'AIR'
		floor_biome.RIVER_TILE.LAVA:
			if randint >= rivertile_chance - Affinity_Fire - 100:
				river_tile = 'LAVA'
			elif randint >= rivertile_chance - Affinity_Fire - 100 - Affinity_Water:
				river_tile = 'WATER'
			else:
				river_tile = 'AIR'
		floor_biome.RIVER_TILE.AIR:
			if randint >= rivertile_chance - Affinity_Air - 100:
				river_tile = 'AIR'
			elif randint >= rivertile_chance - Affinity_Air - 100 - Affinity_Water:
				river_tile = 'WATER'
			else:
				river_tile = 'LAVA'
	match floor_biome.FloodTile:
		floor_biome.FLOOD_TILE.WATER:
			flood_tile = 'WATER'
		floor_biome.FLOOD_TILE.LAVA:
			flood_tile = 'LAVA'
		floor_biome.FLOOD_TILE.AIR:
			flood_tile = 'AIR'

var TypeMoblists = ["res://Resources/Units/_TypeLists/MORTAL.tres","res://Resources/Units/_TypeLists/UNDEAD.tres",\
"res://Resources/Units/_TypeLists/ELEMENTAL.tres","res://Resources/Units/_TypeLists/CONSTRUCT.tres",\
"res://Resources/Units/_TypeLists/BEAST.tres","res://Resources/Units/_TypeLists/WILDLING.tres"]

func set_enemy_spawn_pool():
	Common_Enemies.clear()
	Rare_Enemies.clear()
	Common_Enemies = floor_biome.Common_Enemies.duplicate()
	Rare_Enemies = floor_biome.Rare_Enemies.duplicate()
	
	for type in range(0,6):
		var moblist:TypeList = load(TypeMoblists[type])
		var type_chance_up = 0
		match type:
			0:
				type_chance_up = MobType_Mortal
			1:
				type_chance_up = MobType_Undead
			2:
				type_chance_up = MobType_Elemental
			3:
				type_chance_up = MobType_Construct
			4:
				type_chance_up = MobType_Beast
			5:
				type_chance_up = MobType_Wildling
		for i in range(0,100,25):
			if i <= type_chance_up and type_chance_up > 0:
				Common_Enemies.append(moblist.Common_Enemies.pick_random())
		if type_chance_up >= 100:
			for i in range(75,type_chance_up,25):
				Rare_Enemies.append(moblist.Rare_Enemies.pick_random())
	
	for enem in Common_Enemies:
		print("printest- name:",enem.UnitName," elem:",enem.Element," forcenum:",enem.ElementType.FORCE,"fireaff:",Affinity_Fire)
		if enem.Element == enem.ElementType.FORCE:
			var new_enem:StatComponent = enem.duplicate()
			if Affinity_Fire >= randi_range(0,100) and Affinity_Fire > 0:
				print("new common fire enem")
				new_enem.Element = enem.ElementType.FIRE
				new_enem.UnitName = str('Fire ',enem.UnitName) #Element Corrupted Unit Name?
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Common_Enemies.append(new_enem)
			if Affinity_Water >= randi_range(0,100) and Affinity_Water > 0:
				new_enem.Element = enem.ElementType.WATER
				new_enem.UnitName = str('Water ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Common_Enemies.append(new_enem)
			if Affinity_Earth >= randi_range(0,100) and Affinity_Earth > 0:
				new_enem.Element = enem.ElementType.EARTH
				new_enem.UnitName = str('Earth ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Common_Enemies.append(new_enem)
			if Affinity_Air >= randi_range(0,100) and Affinity_Air > 0:
				new_enem.Element = enem.ElementType.AIR
				new_enem.UnitName = str('Air ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Common_Enemies.append(new_enem)
			if Affinity_Light >= randi_range(0,100) and Affinity_Light > 0:
				new_enem.Element = enem.ElementType.LIGHT
				new_enem.UnitName = str('Light ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Common_Enemies.append(new_enem)
			if Affinity_Dark >= randi_range(0,100) and Affinity_Dark > 0:
				new_enem.Element = enem.ElementType.DARK
				new_enem.UnitName = str('Dark ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Common_Enemies.append(new_enem)
	
	for enem in Rare_Enemies:
		if enem.Element == enem.ElementType.FORCE:
			var new_enem:StatComponent = enem.duplicate()
			if Affinity_Fire >= randi_range(0,100) and Affinity_Fire > 0:
				new_enem.Element = enem.ElementType.FIRE
				new_enem.UnitName = str('Fire ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				#not running for rest, since determined on spawn
				#also, narratively, default nature being corrupted by elemental energy
				#but not affecting learned knowledge works, kinda.
				Rare_Enemies.append(new_enem)
			if Affinity_Water >= randi_range(0,100) and Affinity_Water > 0:
				new_enem.Element = enem.ElementType.WATER
				new_enem.UnitName = str('Water ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Rare_Enemies.append(new_enem)
			if Affinity_Earth >= randi_range(0,100) and Affinity_Earth > 0:
				new_enem.Element = enem.ElementType.EARTH
				new_enem.UnitName = str('Earth ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Rare_Enemies.append(new_enem)
			if Affinity_Air >= randi_range(0,100) and Affinity_Air > 0:
				new_enem.Element = enem.ElementType.AIR
				new_enem.UnitName = str('Air ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Rare_Enemies.append(new_enem)
			if Affinity_Light >= randi_range(0,100) and Affinity_Light > 0:
				new_enem.Element = enem.ElementType.LIGHT
				new_enem.UnitName = str('Light ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Rare_Enemies.append(new_enem)
			if Affinity_Dark >= randi_range(0,100) and Affinity_Dark > 0:
				new_enem.Element = enem.ElementType.DARK
				new_enem.UnitName = str('Dark ',enem.UnitName)
				new_enem.BasicAttack = change_ability_element(new_enem.Element,new_enem.BasicAttack)
				Rare_Enemies.append(new_enem)
	
	


func change_ability_element(element_index:int,ability:AbilityData):
	var elem_vfx = ["res://Art/VFX Sprites/vfx_fire.png","res://Art/VFX Sprites/vfx_water.png",\
	"res://Art/VFX Sprites/vfx_earth.png","res://Art/VFX Sprites/vfx_wind.png",\
	"res://Art/VFX Sprites/vfx_force.png","res://Art/VFX Sprites/vfx_light.png","res://Art/VFX Sprites/vfx_dark.png"]
	var new_ability:AbilityData = ability.duplicate()
	new_ability.element = element_index
	new_ability.vfx = load(elem_vfx[element_index])
	return new_ability

func set_item_spawn_pool():
	print("FLOOR #",current_floor)
	print(" pre clear; biome:",floor_biome.BiomeID," CI",floor_biome.Common_Items," RI",floor_biome.Rare_Items)
	Common_Items.clear()
	Rare_Items.clear()
	var drops = floor_biome.get_drop_pools(AREA_LEVEL)
	Common_Items = floor_biome.Common_Items.duplicate()
	Rare_Items = floor_biome.Rare_Items.duplicate()
	
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
		if not (item.min_area_level > AREA_LEVEL or item.max_area_level < AREA_LEVEL):
			filtered_items.append(item)
	all_items = filtered_items
	
	for item:ItemData in all_items:
		if not item.Affinity_Force:
			if item.Affinity_Dark and Affinity_Dark/100 >= randf():
				if item.rarity < 2:
					Common_Items.append(item)
					if item.rarity < 1:
						Common_Items.append(item)
				else:
					Rare_Items.append(item)
					if item.rarity < 3: #adds Elite items to the pool twice,
						Rare_Items.append(item) #making less rare than uniques.
			elif item.Affinity_Light and Affinity_Light/100 >= randf():
				if item.rarity < 2:
					Common_Items.append(item)
					if item.rarity < 1:
						Common_Items.append(item)
				else:
					Rare_Items.append(item)
					if item.rarity < 3: #adds Elite items to the pool twice,
						Rare_Items.append(item) #making less rare than uniques.
			elif floor_biome.BiomeID != 1 and item.Affinity_Fire and Affinity_Fire/200 >= randf():
				if item.rarity < 2:
					Common_Items.append(item)
					if item.rarity < 1:
						Common_Items.append(item)
				else:
					Rare_Items.append(item)
					if item.rarity < 3: #adds Elite items to the pool twice,
						Rare_Items.append(item) #making less rare than uniques.
			elif floor_biome.BiomeID != 2 and item.Affinity_Water and Affinity_Water/200 >= randf():
				if item.rarity < 2:
					Common_Items.append(item)
					if item.rarity < 1:
						Common_Items.append(item)
				else:
					Rare_Items.append(item)
					if item.rarity < 3: #adds Elite items to the pool twice,
						Rare_Items.append(item) #making less rare than uniques.
			elif floor_biome.BiomeID != 3 and item.Affinity_Earth and Affinity_Earth/200 >= randf():
				if item.rarity < 2:
					Common_Items.append(item)
					if item.rarity < 1:
						Common_Items.append(item)
				else:
					Rare_Items.append(item)
					if item.rarity < 3: #adds Elite items to the pool twice,
						Rare_Items.append(item) #making less rare than uniques.
			elif floor_biome.BiomeID != 4 and item.Affinity_Air and Affinity_Air/200 >= randf():
				if item.rarity < 2:
					Common_Items.append(item)
					if item.rarity < 1:
						Common_Items.append(item)
				else:
					Rare_Items.append(item)
					if item.rarity < 3: #adds Elite items to the pool twice,
						Rare_Items.append(item) #making less rare than uniques.
			
	for item:ItemData in all_items:
		if item.Affinity_Light or item.Affinity_Dark or item.Affinity_Force:
			if item.rarity < 2:
				Common_Items.append(item)
			else:
				Rare_Items.append(item)
				if item.rarity < 3: #adds Elite items to the pool twice,
					Rare_Items.append(item) #making less rare than uniques.

	print("post clear; biome:",floor_biome.BiomeID," CI",floor_biome.Common_Items," RI",floor_biome.Rare_Items)


func finish_dungeon():
	self.reset_data()
	get_tree().change_scene_to_file("res://Scenes/StaticLevels/HubScene_Playtesting.tscn")
	pass
