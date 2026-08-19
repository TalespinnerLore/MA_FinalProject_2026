extends Node

const save_location1 = "user://TowerOfTrials_SaveFile1.tres"
const save_location2 = "user://TowerOfTrials_SaveFile2.tres"

var SaveFileData:SaveDataResource = SaveDataResource.new()


func _ready() -> void:
	_load(1)


func _save(savefile:int):
	var file_loc = "user://TowerOfTrials_SaveFile1.tres"
	match savefile:
		1:
			save_location1
		2:
			save_location2
	ResourceSaver.save(SaveFileData,file_loc)


func _load(savefile:int):
	var file_loc = "user://TowerOfTrials_SaveFile1.tres"
	match savefile:
		1:
			save_location1
		2:
			save_location2
	if FileAccess.file_exists(file_loc):
		SaveFileData = ResourceLoader.load(file_loc).duplicate(true)

func _load_devfile():
	SaveFileData = load("res://_SaveLoad/devtestsave.tres").duplicate(true)
	
func _reset_save_file(savefile:int):
	SaveFileData = SaveDataResource.new()
	_save(savefile)

func save_current_playerdata():
	SaveFileData.p1_class = PlayerStats.p1_class
	SaveFileData.p1_weapon = PlayerStats.p1_weapon
	SaveFileData.p1_armour = PlayerStats.p1_armour
	SaveFileData.p1_trinket = PlayerStats.p1_trinket
	SaveFileData.p1_trinket_slot_stacksize = PlayerStats.p1_trinket_slot_stacksize
	SaveFileData.p1_equipped_abilities = PlayerStats.p1_equipped_abilities
	SaveFileData.p1_ability_usesB1234WAT = PlayerStats.p1_ability_usesB1234WAT
	SaveFileData.p1_HP = PlayerStats.p1_HP
	SaveFileData.p1_level = PlayerStats.p1_level
	SaveFileData.p1_XP = PlayerStats.p1_XP
	SaveFileData.p1_investedStrDexVitMagDefLuk = PlayerStats.p1_investedStrDexVitMagDefLuk
	SaveFileData.p1_free_stats = PlayerStats.p1_free_stats
	SaveFileData.player_inventory = PlayerStats.player_inventory
	SaveFileData.inventory_size = PlayerStats.inventory_size
	SaveFileData.player_gold = PlayerStats.player_gold
	
	if DungeonData.current_floor > 1:
		SaveFileData.is_in_dungeon = true
	else:
		SaveFileData.is_in_dungeon = false

func save_dungeon_data():
	SaveFileData.Affinity_Fire = DungeonData.Affinity_Fire
	SaveFileData.Affinity_Water = DungeonData.Affinity_Water
	SaveFileData.Affinity_Earth = DungeonData.Affinity_Earth
	SaveFileData.Affinity_Air = DungeonData.Affinity_Air
	SaveFileData.Affinity_Force = DungeonData.Affinity_Force
	SaveFileData.Affinity_Light = DungeonData.Affinity_Light
	SaveFileData.Affinity_Dark = DungeonData.Affinity_Dark

	SaveFileData.Biome_Test = DungeonData.Biome_Test
	SaveFileData.Biome_Volcano = DungeonData.Biome_Volcano
	SaveFileData.Biome_Island = DungeonData.Biome_Island
	SaveFileData.Biome_Mesa = DungeonData.Biome_Mesa
	SaveFileData.Biome_Skyland = DungeonData.Biome_Skyland

	SaveFileData.EnvFeature_River = DungeonData.EnvFeature_River
	SaveFileData.EnvFeature_Lake = DungeonData.EnvFeature_Lake
	SaveFileData.EnvFeature_Flooded = DungeonData.EnvFeature_Flooded
	SaveFileData.EnvFeature_Barren = DungeonData.EnvFeature_Barren

	SaveFileData.Halls_DeadEnds = DungeonData.Halls_DeadEnds
	SaveFileData.Rooms_Round = DungeonData.Rooms_Round
	SaveFileData.Rooms_DenseLayout = DungeonData.Rooms_DenseLayout
	SaveFileData.Rooms_SparceLayout = DungeonData.Rooms_SparceLayout
	SaveFileData.Rooms_AlternatingSize = DungeonData.Rooms_AlternatingSize
	SaveFileData.Rooms_Small = DungeonData.Rooms_Small
	SaveFileData.Rooms_Large = DungeonData.Rooms_Large

	SaveFileData.ItemType_Gold = DungeonData.ItemType_Gold
	SaveFileData.ItemType_Tiles = DungeonData.ItemType_Tiles
	SaveFileData.ItemType_Consumable = DungeonData.ItemType_Consumable
	SaveFileData.ItemType_Gear = DungeonData.ItemType_Gear
	SaveFileData.ItemType_Lockboxes = DungeonData.ItemType_Lockboxes
	SaveFileData.ItemType_KeyItem = DungeonData.ItemType_KeyItem

	SaveFileData.ItemMods_SpawnRate = DungeonData.ItemMods_SpawnRate

	SaveFileData.GearType_Weapon = DungeonData.GearType_Weapon
	SaveFileData.GearType_Armour = DungeonData.GearType_Armour
	SaveFileData.GearType_Trinket = DungeonData.GearType_Trinket

	SaveFileData.Class_Vanguard = DungeonData.Class_Vanguard
	SaveFileData.Class_Warrior = DungeonData.Class_Warrior
	SaveFileData.Class_Mage = DungeonData.Class_Mage
	SaveFileData.Class_Rogue = DungeonData.Class_Rogue
	SaveFileData.Class_Healer = DungeonData.Class_Healer
	SaveFileData.Class_Jester = DungeonData.Class_Jester

	SaveFileData.MobType_Beast = DungeonData.MobType_Beast
	SaveFileData.MobType_Elemental = DungeonData.MobType_Elemental
	SaveFileData.MobType_Undead = DungeonData.MobType_Elemental
	SaveFileData.MobType_Construct = DungeonData.MobType_Construct
	SaveFileData.MobType_Mortal = DungeonData.MobType_Mortal
	SaveFileData.MobType_Wildling = DungeonData.MobType_Wildling

	SaveFileData.MobMods_SpawnRate = DungeonData.MobMods_SpawnRate
	SaveFileData.MobMods_Level = DungeonData.MobMods_Level
	SaveFileData.MobMods_EXP = DungeonData.MobMods_EXP
	SaveFileData.MobMods_Gold = DungeonData.MobMods_Gold
	SaveFileData.MobMods_Gear = DungeonData.MobMods_Gear

	SaveFileData.UniqueRooms_TreasureVault = DungeonData.UniqueRooms_TreasureVault
	SaveFileData.UniqueRooms_MonsterHouse = DungeonData.UniqueRooms_MonsterHouse

	SaveFileData.Boss_T0_Roaming = DungeonData.Boss_T0_Roaming
	SaveFileData.Boss_T0_Mini = DungeonData.Boss_T0_Mini
	SaveFileData.Boss_T1_Generic = DungeonData.Boss_T1_Generic
	SaveFileData.Boss_T1_Fire = DungeonData.Boss_T1_Fire
	SaveFileData.Boss_T1_Water = DungeonData.Boss_T1_Water
	SaveFileData.Boss_T1_Earth = DungeonData.Boss_T1_Earth
	SaveFileData.Boss_T1_Wind = DungeonData.Boss_T1_Wind
	SaveFileData.Boss_T1_Force = DungeonData.Boss_T1_Force
	SaveFileData.Boss_T2_Generic = DungeonData.Boss_T2_Generic
	SaveFileData.Boss_T2_QuadElement = DungeonData.Boss_T2_QuadElement
	SaveFileData.Boss_T2_Force = DungeonData.Boss_T2_Force

	SaveFileData.extra_floors = DungeonData.extra_floors
	SaveFileData.has_boss = DungeonData.has_boss

	SaveFileData.final_floor_layout = DungeonData.final_floor_layout
	SaveFileData.safe_room_floor_layout = DungeonData.safe_room_floor_layout
	SaveFileData.boss = DungeonData.boss
	SaveFileData.mini_bosses = DungeonData.mini_bosses
	SaveFileData.elites = DungeonData.elites
	SaveFileData.minis = DungeonData.minis
	SaveFileData.houses = DungeonData.houses
	SaveFileData.vaults = DungeonData.vaults
	SaveFileData.safe_floors = DungeonData.safe_floors
	SaveFileData.floors_special_features = DungeonData.floors_special_features
	SaveFileData.final_floor = DungeonData.final_floor
	SaveFileData.PRESET_Recipie = DungeonData.PRESET_Recipie

	SaveFileData.crafting_tier = DungeonData.crafting_tier

	SaveFileData.AREA_LEVEL = DungeonData.AREA_LEVEL
	SaveFileData.UNIT_LEVEL_Boost = DungeonData.UNIT_LEVEL_Boost
	SaveFileData.max_wandering_units = DungeonData.max_wandering_units
	SaveFileData.max_floors = DungeonData.max_floors
	SaveFileData.current_floor = DungeonData.current_floor

	SaveFileData.room_attempts = DungeonData.room_attempts
	SaveFileData.interconnectivity = DungeonData.interconnectivity
	SaveFileData.rounded = DungeonData.rounded
	SaveFileData.spawn_river = DungeonData.spawn_river
	SaveFileData.flooded = DungeonData.flooded
	SaveFileData.river_tile = DungeonData.river_tile
	SaveFileData.flood_tile = DungeonData.flood_tile
	SaveFileData.max_size = DungeonData.max_size
	SaveFileData.min_size = DungeonData.min_size
	SaveFileData.level_size = DungeonData.level_size

	SaveFileData.floor_biome = DungeonData.floor_biome
	SaveFileData.Common_Enemies = DungeonData.Common_Enemies
	SaveFileData.Rare_Enemies = DungeonData.Rare_Enemies
	SaveFileData.Common_Items = DungeonData.Common_Items
	SaveFileData.Rare_Items = DungeonData.Rare_Items
	SaveFileData.Unique_Rooms = DungeonData.Unique_Rooms


func save_hub_data(BankUI:BankInventoryUI):#is_portal_open:bool
	SaveFileData.bank_gold_val = BankUI.bank_gold_val
	SaveFileData.BankInventory_Resourcestack = BankUI.BankInventory_Resourcestack
	SaveFileData.BankInventory_size = BankUI.BankInventory_size
	#SaveFileData.is_portal_open = is_portal_open



func change_class(newClassName:String):
	var class_data = SaveFileData.stored_character_data.duplicate(true)
	var classname = PlayerStats.p1_class.UnitName
	class_data[classname]['weapon'] = PlayerStats.p1_weapon
	class_data[classname]['armour'] = PlayerStats.p1_armour
	class_data[classname]['trinket'] = PlayerStats.p1_trinket
	class_data[classname]['trinket_slot_stacksize'] = PlayerStats.p1_trinket_slot_stacksize
	class_data[classname]['equipped_abilities'] = PlayerStats.p1_equipped_abilities
	class_data[classname]['level'] = PlayerStats.p1_level
	class_data[classname]['XP'] = PlayerStats.p1_XP
	class_data[classname]['investedStrDexVitMagDefLuk'] = PlayerStats.p1_investedStrDexVitMagDefLuk
	class_data[classname]['free_stats'] = PlayerStats.p1_free_stats
	
	classname = newClassName
	PlayerStats.p1_class = load(class_data[classname]['statComp'])
	PlayerStats.p1_weapon = class_data[classname]['weapon']
	PlayerStats.p1_armour = class_data[classname]['armour']
	PlayerStats.p1_trinket = class_data[classname]['trinket']
	PlayerStats.p1_trinket_slot_stacksize = class_data[classname]['trinket_slot_stacksize']

	PlayerStats.p1_equipped_abilities = class_data[classname]['equipped_abilities']
	PlayerStats.p1_level = class_data[classname]['level']
	PlayerStats.p1_XP = class_data[classname]['XP']
	PlayerStats.p1_investedStrDexVitMagDefLuk = class_data[classname]['investedStrDexVitMagDefLuk']
	PlayerStats.p1_free_stats = class_data[classname]['free_stats']
	
	SaveFileData.stored_character_data = class_data
	#var abs:Array = class_data[classname]['equipped_abilities']
	#print(abs.get_typed_builtin()) ###JUST REMOVED THE TYPEING OF9 THE ARRAYS TO FIX THIS
	pass

func load_player_data():
	PlayerStats.p1_class = SaveFileData.p1_class
	PlayerStats.p1_weapon = SaveFileData.p1_weapon
	PlayerStats.p1_armour = SaveFileData.p1_armour
	PlayerStats.p1_trinket = SaveFileData.p1_trinket
	PlayerStats.p1_trinket_slot_stacksize = SaveFileData.p1_trinket_slot_stacksize
	PlayerStats.p1_equipped_abilities = SaveFileData.p1_equipped_abilities
	PlayerStats.p1_ability_usesB1234WAT = SaveFileData.p1_ability_usesB1234WAT
	PlayerStats.p1_HP = SaveFileData.p1_HP
	PlayerStats.p1_level = SaveFileData.p1_level
	PlayerStats.p1_XP = SaveFileData.p1_XP
	PlayerStats.p1_investedStrDexVitMagDefLuk = SaveFileData.p1_investedStrDexVitMagDefLuk
	PlayerStats.p1_free_stats = SaveFileData.p1_free_stats
	PlayerStats.player_inventory = SaveFileData.player_inventory
	PlayerStats.inventory_size = SaveFileData.inventory_size
	PlayerStats.player_gold = SaveFileData.player_gold
	
func load_dungeon_data():
	DungeonData.Affinity_Fire = SaveFileData.Affinity_Fire
	DungeonData.Affinity_Water = SaveFileData.Affinity_Water
	DungeonData.Affinity_Earth = SaveFileData.Affinity_Earth
	DungeonData.Affinity_Air = SaveFileData.Affinity_Air
	DungeonData.Affinity_Force = SaveFileData.Affinity_Force
	DungeonData.Affinity_Light = SaveFileData.Affinity_Light
	DungeonData.Affinity_Dark = SaveFileData.Affinity_Dark

	DungeonData.Biome_Test = SaveFileData.Biome_Test
	DungeonData.Biome_Volcano = SaveFileData.Biome_Volcano
	DungeonData.Biome_Island = SaveFileData.Biome_Island
	DungeonData.Biome_Mesa = SaveFileData.Biome_Mesa
	DungeonData.Biome_Skyland = SaveFileData.Biome_Skyland

	DungeonData.EnvFeature_River = SaveFileData.EnvFeature_River
	DungeonData.EnvFeature_Lake = SaveFileData.EnvFeature_Lake
	DungeonData.EnvFeature_Flooded = SaveFileData.EnvFeature_Flooded
	DungeonData.EnvFeature_Barren = SaveFileData.EnvFeature_Barren

	DungeonData.Halls_DeadEnds = SaveFileData.Halls_DeadEnds
	DungeonData.Rooms_Round = SaveFileData.Rooms_Round
	DungeonData.Rooms_DenseLayout = SaveFileData.Rooms_DenseLayout
	DungeonData.Rooms_SparceLayout = SaveFileData.Rooms_SparceLayout
	DungeonData.Rooms_AlternatingSize = SaveFileData.Rooms_AlternatingSize
	DungeonData.Rooms_Small = SaveFileData.Rooms_Small
	DungeonData.Rooms_Large = SaveFileData.Rooms_Large

	DungeonData.ItemType_Gold = SaveFileData.ItemType_Gold
	DungeonData.ItemType_Tiles = SaveFileData.ItemType_Tiles
	DungeonData.ItemType_Consumable = SaveFileData.ItemType_Consumable
	DungeonData.ItemType_Gear = SaveFileData.ItemType_Gear
	DungeonData.ItemType_Lockboxes = SaveFileData.ItemType_Lockboxes
	DungeonData.ItemType_KeyItem = SaveFileData.ItemType_KeyItem

	DungeonData.ItemMods_SpawnRate = SaveFileData.ItemMods_SpawnRate

	DungeonData.GearType_Weapon = SaveFileData.GearType_Weapon
	DungeonData.GearType_Armour = SaveFileData.GearType_Armour
	DungeonData.GearType_Trinket = SaveFileData.GearType_Trinket

	DungeonData.Class_Vanguard = SaveFileData.Class_Vanguard
	DungeonData.Class_Warrior = SaveFileData.Class_Warrior
	DungeonData.Class_Mage = SaveFileData.Class_Mage
	DungeonData.Class_Rogue = SaveFileData.Class_Rogue
	DungeonData.Class_Healer = SaveFileData.Class_Healer
	DungeonData.Class_Jester = SaveFileData.Class_Jester

	DungeonData.MobType_Beast = SaveFileData.MobType_Beast
	DungeonData.MobType_Elemental = SaveFileData.MobType_Elemental
	DungeonData.MobType_Undead = SaveFileData.MobType_Elemental
	DungeonData.MobType_Construct = SaveFileData.MobType_Construct
	DungeonData.MobType_Mortal = SaveFileData.MobType_Mortal
	DungeonData.MobType_Wildling = SaveFileData.MobType_Wildling

	DungeonData.MobMods_SpawnRate = SaveFileData.MobMods_SpawnRate
	DungeonData.MobMods_Level = SaveFileData.MobMods_Level
	DungeonData.MobMods_EXP = SaveFileData.MobMods_EXP
	DungeonData.MobMods_Gold = SaveFileData.MobMods_Gold
	DungeonData.MobMods_Gear = SaveFileData.MobMods_Gear

	DungeonData.UniqueRooms_TreasureVault = SaveFileData.UniqueRooms_TreasureVault
	DungeonData.UniqueRooms_MonsterHouse = SaveFileData.UniqueRooms_MonsterHouse

	DungeonData.Boss_T0_Roaming = SaveFileData.Boss_T0_Roaming
	DungeonData.Boss_T0_Mini = SaveFileData.Boss_T0_Mini
	DungeonData.Boss_T1_Generic = SaveFileData.Boss_T1_Generic
	DungeonData.Boss_T1_Fire = SaveFileData.Boss_T1_Fire
	DungeonData.Boss_T1_Water = SaveFileData.Boss_T1_Water
	DungeonData.Boss_T1_Earth = SaveFileData.Boss_T1_Earth
	DungeonData.Boss_T1_Wind = SaveFileData.Boss_T1_Wind
	DungeonData.Boss_T1_Force = SaveFileData.Boss_T1_Force
	DungeonData.Boss_T2_Generic = SaveFileData.Boss_T2_Generic
	DungeonData.Boss_T2_QuadElement = SaveFileData.Boss_T2_QuadElement
	DungeonData.Boss_T2_Force = SaveFileData.Boss_T2_Force

	DungeonData.extra_floors = SaveFileData.extra_floors
	DungeonData.has_boss = SaveFileData.has_boss

	DungeonData.final_floor_layout = SaveFileData.final_floor_layout
	DungeonData.safe_room_floor_layout = SaveFileData.safe_room_floor_layout
	DungeonData.boss = SaveFileData.boss
	DungeonData.mini_bosses = SaveFileData.mini_bosses
	DungeonData.elites = SaveFileData.elites
	DungeonData.minis = SaveFileData.minis
	DungeonData.houses = SaveFileData.houses
	DungeonData.vaults = SaveFileData.vaults
	DungeonData.safe_floors = SaveFileData.safe_floors
	DungeonData.floors_special_features = SaveFileData.floors_special_features
	DungeonData.final_floor = SaveFileData.final_floor
	DungeonData.PRESET_Recipie = SaveFileData.PRESET_Recipie

	DungeonData.crafting_tier = SaveFileData.crafting_tier

	DungeonData.AREA_LEVEL = SaveFileData.AREA_LEVEL
	DungeonData.UNIT_LEVEL_Boost = SaveFileData.UNIT_LEVEL_Boost
	DungeonData.max_wandering_units = SaveFileData.max_wandering_units
	DungeonData.max_floors = SaveFileData.max_floors
	DungeonData.current_floor = SaveFileData.current_floor

	DungeonData.room_attempts = SaveFileData.room_attempts
	DungeonData.interconnectivity = SaveFileData.interconnectivity
	DungeonData.rounded = SaveFileData.rounded
	DungeonData.spawn_river = SaveFileData.spawn_river
	DungeonData.flooded = SaveFileData.flooded
	DungeonData.river_tile = SaveFileData.river_tile
	DungeonData.flood_tile = SaveFileData.flood_tile
	DungeonData.max_size = SaveFileData.max_size
	DungeonData.min_size = SaveFileData.min_size
	DungeonData.level_size = SaveFileData.level_size

	DungeonData.floor_biome = SaveFileData.floor_biome
	DungeonData.Common_Enemies = SaveFileData.Common_Enemies
	DungeonData.Rare_Enemies = SaveFileData.Rare_Enemies
	DungeonData.Common_Items = SaveFileData.Common_Items
	DungeonData.Rare_Items = SaveFileData.Rare_Items
	DungeonData.Unique_Rooms = SaveFileData.Unique_Rooms
	
func load_bank_data(BankUI:BankInventoryUI):
	BankUI.bank_gold_val = SaveFileData.bank_gold_val
	BankUI.BankInventory_Resourcestack = SaveFileData.BankInventory_Resourcestack
	BankUI.BankInventory_size = SaveFileData.BankInventory_size
	#is_portal_open = SaveFileData.is_portal_open
