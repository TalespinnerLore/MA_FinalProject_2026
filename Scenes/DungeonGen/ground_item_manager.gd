extends Node2D
class_name GroundItemManager

var item_scene = preload("res://Objects/Items/GroundItem.tscn")
var item_tile_list:Array[Vector2i] = []
var unplaceable:Array[Vector2i] = []

@onready var unit_manager_ref:Unit_Manager =  get_tree().get_first_node_in_group("UNIT_MANAGER")
@onready var envobj_manager_ref:EnvironmentObjectManager =  get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")
@onready var tilemap_ref:Dungeon_Floor = get_tree().get_first_node_in_group("TILEMAP")

enum ITEM_TYPE {GOLD,TILE,CONSUMABLE,GEAR,LOCKBOX,KEY_ITEM}
enum GEAR_TYPE {N_A,ARMOUR,WEAPON,TRINKET}
enum CONS_TYPE {N_A,EDIBLE,THROWING,KEY,OTHER}
enum CLASS {NONE,VANGUARD,WARRIOR,MAGE,ROGUE,HEALER,JESTER}


func init_items():
	for i in randi_range(int(3*DungeonData.item_mult),int(9*DungeonData.item_mult)):
		var random_tile:Vector2i
		var rareitem_chance = 0.025
		var loot_pool:Array[ItemData]
		if rareitem_chance >= randf_range(0,1):
			loot_pool = DungeonData.Rare_Items
			print("randspawn lootpool - rare")
		else:
			loot_pool = DungeonData.Common_Items
			print("randspawn lootpool - common")
		
		var valid = false
		while valid == false:
			random_tile = tilemap_ref.AllRoomTiles.pick_random()
			if tilemap_ref.cells_Ground.has(random_tile) and ! item_tile_list.has(random_tile):
				valid = true
		spawn_item(random_tile,loot_pool)
	for i in tilemap_ref.DeadEnds:
		var random_tile:Vector2i
		var rareitem_chance = 0.075
		var loot_pool:Array[ItemData]
		if rareitem_chance >= randf_range(0,1):
			loot_pool = DungeonData.Rare_Items
			print("deadend lootpool - rare")
		else:
			loot_pool = DungeonData.Common_Items
			print("deadend lootpool - common")
		random_tile = i[0]
		
		spawn_item(random_tile,loot_pool)


func _ready() -> void:
	#unit_manager_ref =  get_tree().get_first_node_in_group("UNIT_MANAGER")
	#envobj_manager_ref = get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")
	unit_manager_ref =  get_tree().get_first_node_in_group("UNIT_MANAGER")
	envobj_manager_ref = get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")
	tilemap_ref = get_tree().get_first_node_in_group("TILEMAP")
	pass

func drop_item(tile:Vector2i,data:ItemData,stack_size:int):
	unplaceable.clear()
	for i in unit_manager_ref.Active_Units:
		if is_instance_valid(i):
			unplaceable.append(i.self_coords)
	#for i in envobj_manager_ref.unpassable_tiles:
	
	print("tile: ",tile," item: ",data.ItemName," stack: ",stack_size)
	if stack_size < 1:
		stack_size = 1
	var success := false
	var new:GroundItem = item_scene.instantiate()
	new.ITEM_DATA = data
	new.stack_size = stack_size
	new.is_gold = false
	if ! item_tile_list.has(tile) and ! unplaceable.has(tile):
		print("nothing to block, expected:",tile,"real:",Global.grid_to_pos(tile))
		new.global_position = Global.grid_to_pos(tile)
		print("1:",new.global_position)
		add_child(new)
		get_child(-1)._init()
		print("2:",get_child(-1).global_position)
		item_tile_list.append(tile)
		success = true
	else:
		for dir in Global.dir8:
			if ! item_tile_list.has(Vector2i(tile+dir)) and ! unplaceable.has(Vector2i(tile+dir)):
				new.global_position = Global.grid_to_pos(tile+dir)
				add_child(new)
				get_child(-1)._init()
				item_tile_list.append(Vector2i(tile+dir))
				success = true
	new.bugtest()
	print("item locations:",item_tile_list)
	return success


func spawn_item(tile:Vector2i,drop_pool:Array[ItemData]):
	
	print("drop pool:",drop_pool)
	var success := false
	unplaceable.clear()
	for i in unit_manager_ref.Active_Units:
		if is_instance_valid(i):
			unplaceable.append(i.self_coords)
			
	var filtered_drops:Array[ItemData]
	
	var type:ITEM_TYPE = ITEM_TYPE.GOLD
	var g_type:GEAR_TYPE
	var c_type:CONS_TYPE
	var class_type:CLASS
	
	var full_chance = DungeonData.gold_chance + DungeonData.cons_chance + \
	DungeonData.tile_chance + DungeonData.gear_chance + DungeonData.lockbox_chance
	var roll = randf_range(0,full_chance)
	
	if roll <= DungeonData.gold_chance and DungeonData.gold_chance != 0:
		type = ITEM_TYPE.GOLD
		filtered_drops.append(load("res://Resources/Items/Other/Gold.tres"))
	elif roll <= DungeonData.gold_chance + DungeonData.cons_chance and DungeonData.cons_chance != 0:
		type = ITEM_TYPE.CONSUMABLE
	elif roll <= DungeonData.gold_chance + DungeonData.cons_chance + \
	DungeonData.tile_chance and DungeonData.tile_chance != 0:
		type = ITEM_TYPE.TILE
	elif roll <= DungeonData.gold_chance + DungeonData.cons_chance + \
	DungeonData.tile_chance + DungeonData.gear_chance and  DungeonData.gear_chance!= 0:
		type = ITEM_TYPE.GEAR
	elif roll <= DungeonData.gold_chance + DungeonData.cons_chance + \
	DungeonData.tile_chance + DungeonData.gear_chance + DungeonData.lockbox_chance\
	and DungeonData.lockbox_chance != 0:
		type = ITEM_TYPE.LOCKBOX
	
	for item in drop_pool:
		if item.ItemType == type:
			filtered_drops.append(item)
	if filtered_drops.size() < 1: #failsafe, particularly for limited rare item pools
		filtered_drops = drop_pool
	
	if type == ITEM_TYPE.GEAR:
		full_chance = 100+DungeonData.GearType_Armour + DungeonData.GearType_Trinket + DungeonData.GearType_Weapon
		roll = randi_range(0,full_chance)
		if roll <= 100:
			g_type = GEAR_TYPE.N_A
		elif roll <= 100+DungeonData.GearType_Armour and DungeonData.GearType_Armour != 0:
			g_type = GEAR_TYPE.ARMOUR
		elif roll <= 100+DungeonData.GearType_Armour + DungeonData.GearType_Trinket \
		and DungeonData.GearType_Trinket != 0:
			g_type = GEAR_TYPE.TRINKET
		elif roll <= 100+DungeonData.GearType_Armour + DungeonData.GearType_Trinket \
		+ DungeonData.GearType_Weapon and DungeonData.GearType_Weapon != 0:
			g_type = GEAR_TYPE.WEAPON
		
		if g_type != GEAR_TYPE.N_A:
			var gear_filtered:Array[ItemData]
			for item in filtered_drops:
				if item.GearType != g_type:
					gear_filtered.append(item)
			if gear_filtered.size() > 0:
				filtered_drops = gear_filtered
	
	var class_filtered:Array[ItemData]
	full_chance = 100+DungeonData.Class_Healer+DungeonData.Class_Jester+DungeonData.Class_Mage\
	+DungeonData.Class_Rogue+DungeonData.Class_Vanguard+DungeonData.Class_Warrior
	
	roll = randi_range(0,full_chance)
	if roll <= 100:
		class_type = CLASS.NONE
	elif roll <= 100+DungeonData.Class_Healer and DungeonData.Class_Healer!=0:
		class_type = CLASS.HEALER
	elif roll <= 100+DungeonData.Class_Healer+DungeonData.Class_Jester\
	 and DungeonData.Class_Jester!=0:
		class_type = CLASS.JESTER
	elif roll <= 100+DungeonData.Class_Healer+DungeonData.Class_Jester+DungeonData.Class_Mage\
	 and DungeonData.Class_Mage!=0:
		class_type = CLASS.MAGE
	elif roll <= 100+DungeonData.Class_Healer+DungeonData.Class_Jester+DungeonData.Class_Mage\
	+DungeonData.Class_Rogue and DungeonData.Class_Rogue!=0:
		class_type = CLASS.ROGUE
	elif roll <= 100+DungeonData.Class_Healer+DungeonData.Class_Jester+DungeonData.Class_Mage\
	+DungeonData.Class_RogueDungeonData.Class_Vanguard and DungeonData.Class_Vanguard!=0:
		class_type = CLASS.VANGUARD
	elif roll <= 100+DungeonData.Class_Healer+DungeonData.Class_Jester+DungeonData.Class_Mage\
	+DungeonData.Class_RogueDungeonData.Class_Vanguard+DungeonData.Class_Warrior\
	 and DungeonData.Class_Warrior!=0:
		class_type = CLASS.WARRIOR
	
	if class_type != CLASS.NONE:
		for item in filtered_drops:
			if item.Class_Bias == item.CLASS.NONE or item.Class_Bias == class_type:
				class_filtered.append(item)
	if class_filtered.size() > 0:
		filtered_drops = class_filtered
	
	var data:ItemData = filtered_drops.pick_random()
	
	if data == null: #failsafe if flitering borks itself
		data = drop_pool.pick_random()
		print(data," // data was null // newdataname:",data.Itemname)
	var new:GroundItem = item_scene.instantiate()
	new.ITEM_DATA = data
	if data.ItemName != 'Gold':
		new.is_gold = false
	if ! item_tile_list.has(tile) and ! unplaceable.has(tile):
		print("nothing to block, expected:",tile,"real:",Global.grid_to_pos(tile))
		new.global_position = Global.grid_to_pos(tile)
		print("1:",new.global_position)
		add_child(new)
		get_child(-1)._init()
		print("2:",get_child(-1).global_position)
		item_tile_list.append(tile)
		success = true
	else:
		for dir in Global.dir8:
			if ! item_tile_list.has(Vector2i(tile+dir)) and ! unplaceable.has(Vector2i(tile+dir)):
				new.global_position = Global.grid_to_pos(tile+dir)
				add_child(new)
				get_child(-1)._init()
				item_tile_list.append(Vector2i(tile+dir))
				success = true
	new.bugtest()
	print("item locations:",item_tile_list)
	return success
