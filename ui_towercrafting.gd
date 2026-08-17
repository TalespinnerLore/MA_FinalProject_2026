class_name TOWER_CRAFTING_UI
extends Node2D

#vvvvvTO BE DELETED, OUT OF DATEvvvvv
@export var TileID_Inventory = [0,0,0,0,1,1,1,1,2,2,3,3,4,4,5,6,6,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,0,0,0,0,1,1,1,1,2,2,3,3,4,4,5,6,6,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,0,0,0,0,1,1,1,1,2,2,3,3,4,4,5,6,6,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,0,0,0,0,1,1,1,1,2,2,3,3,4,4,5,6,6,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52]
#^^^^^TO BE DELETED, OUT OF DATE^^^^^

var inventory_grid_size = Vector2i(3,9)
var current_page:int = -1
var max_page_num:int = 2
const basetile = preload("res://Crafting/tile_object.tscn")
const basetile_fixed = preload("res://Crafting/DungeonCraftingTile.tscn")

@export var TileID_NamedInventory = [["TEST",0],["FIRE",4],["WATER",4],["EARTH",4],["AIR",4],["FORCE",4],\
["VOLCANO",4],["ISLANDS",4],["MESA",4],["SKY_ISLANDS",4],\
["RIVER",4],["LAKE",2],["ROUND_ROOMS",4],["DENSE_LAYOUT",2],["SPARSE_LAYOUT",2],["ALTERNATING_SIZE_ROOMS",2],["SMALL_ROOMS",2],["LARGE_ROOMS",2],\
["CONSUMABLES",2],["GEAR",2],["LOCKBOXES",2],["WEAPONS",2],["ARMOUR",2],["TRINKETS",2],\
["VANGUARD",1],["WARRIOR",1],["MAGE",1],["ROGUE",1],["HEALER",1],["JESTER",1],\
["INCREASED_MOB_DENSITY",2],["INCREASED_GOLD",4],["INCREASED_XP",2],["DECREASED_MOB_DENSITY",2],["DECREASED_GOLD",2],["DECREASED_XP",2],\
["BEASTS",1],["ELEMENTALS",1],["UNDEAD",1],["CONSTRUCTS",1],["MORTALS",2],["WILDLINGS",2],\
["TREASURE_ROOM",1],["MINI_BOSS",1],["MONSTER_HOUSE",1],\
["T1_BOSS",1],["T1_FIREBOSS",0],["T1_WATERBOSS",1],["T1_EARTHBOSS",0],["T1_AIRBOSS",0],["T1_FORCEBOSS",1],\
["T2_BOSS",1],["T2_QUADBOSS",0],["T2_FORCEBOSS",0]]

var tile_paths = ["res://Resources/Items/Tiles/DungeonGen/Elements/TEST.tres","res://Resources/Items/Tiles/DungeonGen/Elements/FIRE.tres",\
"res://Resources/Items/Tiles/DungeonGen/Elements/WATER.tres","res://Resources/Items/Tiles/DungeonGen/Elements/EARTH.tres",\
"res://Resources/Items/Tiles/DungeonGen/Elements/AIR.tres","res://Resources/Items/Tiles/DungeonGen/Elements/FORCE.tres",\
"res://Resources/Items/Tiles/DungeonGen/Biome/VOLCANO.tres","res://Resources/Items/Tiles/DungeonGen/Biome/ISLAND.tres",\
"res://Resources/Items/Tiles/DungeonGen/Biome/MESA.tres","res://Resources/Items/Tiles/DungeonGen/Biome/SKYLAND.tres",\
"res://Resources/Items/Tiles/DungeonGen/Environment/RIVER_SPAWN.tres","res://Resources/Items/Tiles/DungeonGen/Environment/LAKE_SPAWN.tres",\
"res://Resources/Items/Tiles/DungeonGen/Rooms/ROUND_ROOMS.tres","res://Resources/Items/Tiles/DungeonGen/Rooms/DENSE_LAYOUT.tres",\
"res://Resources/Items/Tiles/DungeonGen/Rooms/SPARSE_LAYOUT.tres","res://Resources/Items/Tiles/DungeonGen/Rooms/ALTERNATING_SIZE_ROOMS.tres",\
"res://Resources/Items/Tiles/DungeonGen/Rooms/SMALL_ROOMS.tres","res://Resources/Items/Tiles/DungeonGen/Rooms/LARGE_ROOMS.tres",\
"res://Resources/Items/Tiles/DungeonGen/Items/CONSUMABLE.tres","res://Resources/Items/Tiles/DungeonGen/Items/GEAR.tres",\
"res://Resources/Items/Tiles/DungeonGen/Items/LOCKBOX.tres","res://Resources/Items/Tiles/DungeonGen/Items/WEAPON.tres",\
"res://Resources/Items/Tiles/DungeonGen/Items/ARMOUR.tres","res://Resources/Items/Tiles/DungeonGen/Items/TRINKET.tres",\
"res://Resources/Items/Tiles/DungeonGen/Classes/VANGUARD.tres","res://Resources/Items/Tiles/DungeonGen/Classes/WARRIOR.tres",\
"res://Resources/Items/Tiles/DungeonGen/Classes/MAGE.tres","res://Resources/Items/Tiles/DungeonGen/Classes/ROUGUE.tres",\
"res://Resources/Items/Tiles/DungeonGen/Classes/HEALER.tres","res://Resources/Items/Tiles/DungeonGen/Classes/JESTER.tres",\
"res://Resources/Items/Tiles/DungeonGen/Misq/INCREASED_MOB_DENSITY.tres","res://Resources/Items/Tiles/DungeonGen/Misq/INCREASED_GOLD.tres",\
"res://Resources/Items/Tiles/DungeonGen/Misq/INCREASED_XP.tres","res://Resources/Items/Tiles/DungeonGen/Misq/DECREASED_MOB_DENSITY.tres",\
"res://Resources/Items/Tiles/DungeonGen/Misq/DECREASED_GOLD.tres","res://Resources/Items/Tiles/DungeonGen/Misq/DECREASED_XP.tres",\
"res://Resources/Items/Tiles/DungeonGen/MOBS/BEASTS.tres","res://Resources/Items/Tiles/DungeonGen/MOBS/ELEMENTALS.tres",\
"res://Resources/Items/Tiles/DungeonGen/MOBS/UNDEAD.tres","res://Resources/Items/Tiles/DungeonGen/MOBS/CONSTRUCTS.tres",\
"res://Resources/Items/Tiles/DungeonGen/MOBS/MORTALS.tres","res://Resources/Items/Tiles/DungeonGen/MOBS/WILDLINGS.tres",\
"res://Resources/Items/Tiles/DungeonGen/Unique Rooms/TREASURE_VAULT.tres","res://Resources/Items/Tiles/DungeonGen/BOSSES/MINI_BOSS.tres",\
"res://Resources/Items/Tiles/DungeonGen/Unique Rooms/MONSTER_HOUSE.tres","res://Resources/Items/Tiles/DungeonGen/BOSSES/T1_BOSS.tres",\
"res://Resources/Items/Tiles/DungeonGen/BOSSES/T1_FIREBOSS.tres","res://Resources/Items/Tiles/DungeonGen/BOSSES/T1_WATERBOSS.tres",\
"res://Resources/Items/Tiles/DungeonGen/BOSSES/T1_EARTHBOSS.tres","res://Resources/Items/Tiles/DungeonGen/BOSSES/T1_AIRBOSS.tres",\
"res://Resources/Items/Tiles/DungeonGen/BOSSES/T1_FORCEBOSS.tres","res://Resources/Items/Tiles/DungeonGen/BOSSES/T2_BOSS.tres",\
"res://Resources/Items/Tiles/DungeonGen/BOSSES/T2_QUADBOSS.tres","res://Resources/Items/Tiles/DungeonGen/BOSSES/T2_FORCEBOSS.tres"]

func populate_inventory_named():
	print("POPULATING_named")
	var ID_index = -1
	for ID in TileID_NamedInventory:
		ID_index+=1
		if ID[1] > 0:
			if ID_index-(inventory_grid_size.x*inventory_grid_size.y*current_page) < (inventory_grid_size.x*inventory_grid_size.y) \
			and ID_index-(inventory_grid_size.x*inventory_grid_size.y*current_page) >= 0:
				var tile = basetile.instantiate()
				tile.position = Vector2(32+32*((ID_index-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x),52+32*((ID_index-inventory_grid_size.x*inventory_grid_size.y*current_page)/inventory_grid_size.x))
				tile.TILE_ID = ID_index
				self.add_child(tile)

func populate_inventory_named_fixed():
	print("POPULATING_named_fixed")
	var ID_index = -1
	for ID in TileID_NamedInventory:
		ID_index+=1
		if ID_index-(inventory_grid_size.x*inventory_grid_size.y*current_page) < (inventory_grid_size.x*inventory_grid_size.y) \
		and ID_index-(inventory_grid_size.x*inventory_grid_size.y*current_page) >= 0:
			var tile = basetile_fixed.instantiate()
			tile.position = Vector2(32+32*((ID_index-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x),52+32*((ID_index-inventory_grid_size.x*inventory_grid_size.y*current_page)/inventory_grid_size.x))
			tile.data = load(tile_paths[ID_index])
			tile.num_in_inventory = ID[1]
			self.add_child(tile)

func adjust_count_named_fixed(TILE_ID:int, adding:bool):
	var ID = TILE_ID
	var amount = TileID_NamedInventory[ID][1]
	if adding:
		TileID_NamedInventory[ID][1] = clampi(amount+1,0,9999)
	else:
		TileID_NamedInventory[ID][1] = clampi(amount-1,0,9999) 
	var tile = get_child(3+ID-((current_page+1)*inventory_grid_size.x*inventory_grid_size.y))
	if tile is DungeonCraftingTile and tile.data.TILE_ID == ID:
		tile.check_visible()
	#populate_inventory_named_fixed()
	pass

func change_page_fixed(next:bool):
	print('@old page',current_page)
	if next: 
		current_page = clampi(current_page+1,0,max_page_num) 
	else:             #clamped between 0 and max page count
		current_page = clampi(current_page-1,0,max_page_num)
	print('@new page',current_page)
	for i in max_page_num+1:
		var page = self.get_child(i)
		if i == current_page:
			page.visible = true
		else:
			page.visible = false
	for i in range(max_page_num+1,get_child_count()):
		get_child(i).queue_free()
	#for child in get_children():
	#	print(child.get_class())
	#	if child.get_class() != 'TileMapLayer':
	#		print("freeing ",child.get_class())
			#queue_free()
			#pass
	populate_inventory_named_fixed()
	pass

func adjust_count_named(TILE_ID:int, adding:bool):
	var ID = TILE_ID
	var amount = TileID_NamedInventory[ID][1]
	if adding:
		TileID_NamedInventory[ID][1] = clampi(amount+1,0,9999)
	else:
		TileID_NamedInventory[ID][1] = clampi(amount-1,0,9999) 
	for child in get_children():
		if child is CRAFTING_TILE_TOWER:
			if not child.is_placed: #all objects that are 
				child.queue_free()  # so no need for error checking here.
	populate_inventory_named()
	#if TileID_NamedInventory[ID][1] == 1 and (current_page+1)*inventory_grid_size.x*inventory_grid_size.y > ID and ID >= clampi(current_page-1,0,max_page_num)*inventory_grid_size.length():
	#	var tile = basetile.instantiate()
	#	print("ID:",ID," GridCoord: ",Vector2((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x,(ID-inventory_grid_size.x*inventory_grid_size.y*current_page)/3))
	#	tile.position = Vector2(32+32*((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x),52+32*((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)/inventory_grid_size.x))
	#	tile.TILE_ID = ID
	#	self.add_child(tile)
	pass


@export_category("DungeonGen")
@export var Affinity = [[Global.DG_Mods["ELEMENTS"][0],0],[Global.DG_Mods["ELEMENTS"][1],0],[Global.DG_Mods["ELEMENTS"][2],0],[Global.DG_Mods["ELEMENTS"][3],0],[Global.DG_Mods["ELEMENTS"][4],0],[Global.DG_Mods["ELEMENTS"][5],0],[Global.DG_Mods["ELEMENTS"][6],0]]
#[[Global.ELEMENTS.FIRE,0],[Global.ELEMENTS.WATER,0],[Global.ELEMENTS.EARTH,0],[Global.ELEMENTS.AIR,0],[Global.ELEMENTS.FORCE,0],[Global.ELEMENTS.LIGHT,0],[Global.ELEMENTS.DARK,0]]
@export var Environments:Array = [[Global.DG_Mods["BIOMES"][0],0],[Global.DG_Mods["BIOMES"][1],0],[Global.DG_Mods["BIOMES"][2],0],[Global.DG_Mods["BIOMES"][3],0],[Global.DG_Mods["BIOMES"][4],0],\
								[Global.DG_Mods["ENV_FEATURES"][0],0],[Global.DG_Mods["ENV_FEATURES"][1],0],[Global.DG_Mods["ENV_FEATURES"][2],0],[Global.DG_Mods["ENV_FEATURES"][3],0],\
								[Global.DG_Mods["ROOMS"][0],0],[Global.DG_Mods["ROOMS"][1],0],[Global.DG_Mods["ROOMS"][2],0],[Global.DG_Mods["ROOMS"][3],0],[Global.DG_Mods["ROOMS"][4],0],[Global.DG_Mods["ROOMS"][5],0]]
#= [[Global.BIOMES.TEST,0],[Global.BIOMES.VOLCANO,0],[Global.BIOMES.ISLAND,0],[Global.BIOMES.MESA,0],[Global.BIOMES.SKY_ISLAND,0],\
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

func change_modifiers(affinity:Array,environ:Array,mobs:Array,loot:Array,spec_feats:Array,adding:bool):
	var x = 1
	if not adding:
		x = -1
	if affinity != []:
		for a in affinity:
			for i in Affinity:
				if a[0] == i[0]:
					i[1] += x*a[1]
	if environ != []:
		for e in environ:
			for i in Environments:
				if e[0] == i[0]:
					i[1] += x*e[1]
	if mobs != []:
		for m in mobs:
			for i in Enemies:
				if m[0] == i[0]:
					i[1] += x*m[1]
	if loot != []:
		for l in loot:
			for i in Loot:
				if l[0] == i[0]:
					i[1] += x*l[1]
	if spec_feats != []:
		for sf in spec_feats:
			for i in Special_Features:
				if sf[0] == i[0]:
					i[1] += x*sf[1]
	modifier_text()

func modifier_text():
	var a_text = ""
	var e_text = ""
	var m_text = ""
	var l_text = ""
	var sf_text = ""
	for i in Affinity:
		if i[1] != 0:
			a_text += "  "+i[0]+" + "+str(i[1]*25)+"%\n"
	for i in Environments:
		if i[1] != 0:
			e_text += "  "+i[0]+" + "+str(i[1]*25)+"%\n"
	for i in Enemies:
		if i[1] != 0:
			if Enemies.find(i) == 0:
				m_text += "  "+i[0]+" + "+str(i[1]*5)+"%\n"
			elif Enemies.find(i) == 1:
				m_text += "  "+i[0]+" + "+str(i[1])+"\n"
			else:
				m_text += "  "+i[0]+" + "+str(i[1]*25)+"%\n"
	for i in Loot:
		if i[1] != 0:
			if Loot.find(i) == 0:
				l_text += "  "+i[0]+" + "+str(i[1]*5)+"%\n"
			else:
				l_text += "  "+i[0]+" + "+str(i[1]*25)+"%\n"
	for i in Special_Features:
		if i[1] != 0:
			sf_text += "  "+i[0]+" + "+str(i[1])+"\n"
	$"../ScrollContainer2/VBoxContainer/affinity".text = a_text
	$"../ScrollContainer2/VBoxContainer/environment".text = e_text
	$"../ScrollContainer2/VBoxContainer/enemies".text = m_text
	$"../ScrollContainer2/VBoxContainer/loot".text = l_text
	$"../ScrollContainer2/VBoxContainer/special_features".text = sf_text

func change_page(next:bool):
	print(Affinity[0][0])
	if next: 
		current_page = clampi(current_page+1,0,max_page_num) 
	else:             #clamped between 0 and max page count
		current_page = clampi(current_page-1,0,max_page_num)
	for i in max_page_num+1:
		var page = self.get_child(i)
		if i == current_page:
			page.visible = true
		else:
			page.visible = false
	#print(self.get_children())
	for child in get_children():
		if child is CRAFTING_TILE_TOWER:
			#if child.TILE_ID > max_page_num+1: #FUKING OUTDATED CODE REEEEEEEEEEEEEEEEE
			if not child.is_placed: #all objects that are 
				child.queue_free()  # so no need for error checking here.
	#print(self.get_children())
	#print(TileID_NamedInventory)
	#for child in self.get_children():
	#	if child is CRAFTING_TILE_TOWER:
	#		print(child.is_placed)
	#populate_inventory_named()
	populate_inventory_named_fixed()
	pass



#vvvvvTO BE DELETED, OUT OF DATEvvvvv
func adjust_count(TILE_ID:int, adding:bool):
	var ID = TILE_ID
	if adding:
		TileID_Inventory.append(ID)
	else:
		TileID_Inventory.erase(ID)
	TileID_Inventory.sort()
	
	if TileID_Inventory.has(ID) and (current_page+1)*inventory_grid_size.x*inventory_grid_size.y > ID and ID >= clampi(current_page-1,0,max_page_num)*inventory_grid_size.length():
		var tile = basetile.instantiate()
		print("ID:",ID," GridCoord: ",Vector2((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x,(ID-inventory_grid_size.x*inventory_grid_size.y*current_page)/3))
		tile.position = Vector2(32+32*((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x),52+32*((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)/inventory_grid_size.x))
		tile.TILE_ID = ID
		self.add_child(tile)
	pass

#vvvvvTO BE DELETED, OUT OF DATEvvvvv
func populate_inventory():
	print("POPULATING")
	var last_ID = -1
	for ID in TileID_Inventory:
		if ID > last_ID:
			last_ID = ID
			print("ID:",ID," LastID:",last_ID)
			#if ID is within 0 and 26, shifted for page count:
			#print((current_page+1)*inventory_grid_size.x*inventory_grid_size.y," > ",ID," >= ",clampi(current_page-1,0,max_page_num)*inventory_grid_size.x*inventory_grid_size.y)
			#if (current_page+1)*inventory_grid_size.x*inventory_grid_size.y > ID and ID >= clampi(current_page-1,0,max_page_num)*inventory_grid_size.x*inventory_grid_size.y:
			if ID-(inventory_grid_size.x*inventory_grid_size.y*current_page) < (inventory_grid_size.x*inventory_grid_size.y) \
			and ID-(inventory_grid_size.x*inventory_grid_size.y*current_page) >= 0:
				#print("is ",ID-(27*current_page)," < 27? And is ",ID-(27*current_page)," >= 0?")
				var tile = basetile.instantiate()
				#print("ID:",ID," GridCoord: ",Vector2((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x,(ID-inventory_grid_size.x*inventory_grid_size.y*current_page)/3))
				tile.position = Vector2(32+32*((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)%inventory_grid_size.x),52+32*((ID-inventory_grid_size.x*inventory_grid_size.y*current_page)/inventory_grid_size.x))
				tile.TILE_ID = ID
				self.add_child(tile)
				pass


func _ready() -> void:
	init()
	pass # Replace with function body.

func init():
	#change_page(true)
	change_page_fixed(true)
	modifier_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed_left() -> void:
	#change_page(false)
	change_page_fixed(false)

func _on_button_pressed_right() -> void:
	#change_page(true)
	change_page_fixed(true)

func _on_button_start_pressed() -> void:
	var savekeys = SaveLoad.SaveFileData.checkpoint_persistance_keys
	if Boss_T0_Mini > 0:
		savekeys['unlocked_recipe_miniboss'] = true
	if UniqueRooms_TreasureVault > 0:
		savekeys['unlocked_recipe_treasurevault'] = true
	if UniqueRooms_MonsterHouse > 0:
		savekeys['unlocked_recipe_monsterhouse'] = true
	if Boss_T1_Force > 0:
		savekeys['unlocked_recipe_forceboss'] = true
	if Boss_T1_Fire > 0:
		savekeys['unlocked_recipe_fireboss'] = true
	if Boss_T1_Water > 0:
		savekeys['unlocked_recipe_waterboss'] = true
	if Boss_T1_Earth > 0:
		savekeys['unlocked_recipe_earthboss'] = true
	if Boss_T1_Wind > 0:
		savekeys['unlocked_recipe_airboss'] = true
	if Boss_T2_Force > 0:
		savekeys['unlocked_recipe_forceboss2'] = true
	if Boss_T2_QuadElement > 0:
		savekeys['unlocked_recipe_quadboss'] = true
	print("testing button")
	#DungeonData.Affinity = Affinity
	#DungeonData.Enemies = Enemies
	#DungeonData.Environments = Environments
	#DungeonData.Loot = Loot
	#DungeonData.Special_Features = Special_Features
	load_data_to_dungeon()
	#DungeonData.choose_biome()
	DungeonData.open_level_new()
	
	pass# Replace with function body.





func print_mods():
	var pastethis = ''
	for key in $"../ButtonSTART/TileObject".Tile_Crafting_Mods.keys():
		pastethis+=('["'+str(key)+'",0],')
	print(pastethis)





















func change_data(data:DUNGEON_CRAFTING_TILE_DATA,adding:bool):
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
	if data.has_boss:
		if adding:
			has_boss = true
		else:
			has_boss = false
		
	show_data()
	if (preset_data == null or ! adding) and data != offset_values and data != preset_data:
		print("hit preset = null / not adding, and data != offset values check")
		# forced recheck when adding a tile with not preset, when you might change
		## that preset by removing a tile, but not when removing the visual offset
		### data that happens when the data is forwarded to DungeonData.
		var preset = get_parent().check_for_preset_recipes()
		if ! preset == null: #if preset is filled:
			var testtext = []
			for q in preset:
				if q != null:
					testtext.append(q.TILE_ID)
				else:
					testtext.append('<null>')
			print("hit preset recipe existing check - IDs:",testtext)
			preset_data = preset[-1] #the preset data that actually is applied (1 tile)
			preset.pop_back()
			offset_values = DUNGEON_CRAFTING_TILE_DATA.new()
			for tile in preset:
				var is_last = false #these are the things we want visually cancelled out (9 tiles)
				if tile == preset[-1]:
					is_last = true #the last is the visual info added (1 tile)
				if tile != null:
					offset_values.combine_data(tile,is_last)
			#change_data(preset_data,true)
			change_data(offset_values,true)
		else:
			print("hit the no precet existing check")
			print(preset_data, offset_values)
			if adding == false and preset_data != null:
				print('change back offset')
				change_data(offset_values,false)
				
			preset_data = null
			offset_values = null
	if Boss_T1_Generic > 0:
		if preset_data == null:
			$"../ButtonSTART".set_disabled(true)
			$"../ButtonSTART".text = 'INVALID'
		elif offset_values != null:
			if offset_values.Boss_T1_Generic != 1:
				$"../ButtonSTART".set_disabled(true)
				$"../ButtonSTART".text = 'INVALID'
			#print('boss offsert',offset_values.Boss_T1_Generic)
			else:
				$"../ButtonSTART".set_disabled(false)
				$"../ButtonSTART".text = 'START'
	elif Boss_T2_Generic > 0:
		if get_parent().grid_level == 4:
			if preset_data == null:
				$"../ButtonSTART".set_disabled(true)
				$"../ButtonSTART".text = 'INVALID'
			elif offset_values != null:
				if offset_values.Boss_T2_Generic != 1:
					$"../ButtonSTART".set_disabled(true)
					$"../ButtonSTART".text = 'INVALID'
				else:
					$"../ButtonSTART".set_disabled(false)
					$"../ButtonSTART".text = 'START'
		else:
			$"../ButtonSTART".set_disabled(true)
			$"../ButtonSTART".text = 'INVALID'
	else:
		$"../ButtonSTART".set_disabled(false)
		$"../ButtonSTART".text = 'START'
	pass

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

@export var preset_data:DCTData_Preset
@export var offset_values:DUNGEON_CRAFTING_TILE_DATA

	

func show_data():
	var aff = [Affinity_Fire,Affinity_Water,Affinity_Earth,Affinity_Air,Affinity_Force,\
	Affinity_Light,Affinity_Dark]
	var aff_desc = ['FIRE', 'WATER','EARTH','AIR','FORCE','LIGHT','DARK']
	var env = [Biome_Test,Biome_Volcano,Biome_Island,Biome_Mesa,Biome_Skyland,\
			EnvFeature_Barren,EnvFeature_Flooded,EnvFeature_Lake,EnvFeature_River,\
			Rooms_Round,Rooms_AlternatingSize,Rooms_Large,Rooms_Small,Rooms_DenseLayout,Rooms_SparceLayout]
	var env_desc = ['TEST_BIOME','VOLCANO BIOME','ISLANDS BIOME','MESA BIOME','SKYLANDS BIOME',\
				'BARREN FLOOR','FLOODED FLOOR','SWAP FLOODING','RIVER SPAWNS',\
				'ROUND ROOMS','SQUARE ROOMS','SMALL ROOMS','LARGE ROOMS','DENSE ROOM LAYOUT','SPARCE ROOM LAYOUT']
	var enem = [MobMods_Level,MobMods_SpawnRate,MobMods_EXP,MobMods_Gold,MobMods_Gear,\
			MobType_Beast,MobType_Elemental,MobType_Undead,MobType_Construct,MobType_Mortal,MobType_Wildling]
	var enem_desc = ['LEVEL','SPAWN RATE','EXP DROPPED','GOLD DROPPED','SPAWN WITH GEAR',\
				'BEAST TYPE','ELEMENTAL TYPE','UNDEAD TYPE'
				,'CONSTRUCT TYPE','MORTAL TYPE','WILDLING TYPE']
	var loot = [ItemMods_SpawnRate,ItemType_Gold,ItemType_Tiles,ItemType_Consumable,ItemType_Gear,ItemType_Lockboxes,ItemType_KeyItem,\
				GearType_Armour,GearType_Weapon,GearType_Trinket,\
				Class_Vanguard,Class_Warrior,Class_Mage,Class_Rogue,Class_Healer,Class_Jester]
	var loot_desc =['INCREASED SPAWN RATE', 'GOLD','TILES','CONSUMABLES','GEAR','LOCKBOXES','KEY ITEMS',\
				'- ARMOUR','- WEAPONS','- TRINKETS',\
				'VANGUARD BIAS','WARRIOR BIAS','MAGE BIAS','ROGUE BIAS','HEALER BIAS','JESTER BIAS']
	var spec_feat = [UniqueRooms_TreasureVault,UniqueRooms_MonsterHouse,Boss_T0_Roaming,Boss_T0_Mini,\
				Boss_T1_Generic,Boss_T1_Fire,Boss_T1_Water,Boss_T1_Earth,Boss_T1_Wind,Boss_T1_Force,\
				Boss_T2_Generic,Boss_T2_QuadElement,Boss_T2_Force]
	var spec_feat_desc = ['TREASURE VAULT','MONSTER HOUSE','WANDERING ELITE','MINI-BOSS',\
						'BOSS - TIER 1','FIRE BOSS - TIER 1','WATER BOSS - TIER 1','EARTH BOSS - TIER 1','AIR BOSS - TIER 1','FORCE BOSS - TIER 1',\
						'BOSS - TIER 2','FINAL BOSS - ELEMENTAL LORD','SECRET BOSS - ARCANE LORD']
	
	var a_text = ""
	var e_text = ""
	var m_text = ""
	var l_text = ""
	var sf_text = ""
	var index = 0
	var pm = ''
	for i in aff:
		if i != 0:
			if i>0:
				a_text += " "+aff_desc[index]+" +"+str(aff[index])+"%\n"
			else:
				a_text += " "+aff_desc[index]+" "+str(aff[index])+"%\n"
		index+=1
	index = 0
	for i in env:
		if i != 0:
			if i >0:
				e_text += " "+env_desc[index]+" +"+str(env[index])+"%\n"
			else:
				e_text += " "+env_desc[index]+" "+str(env[index])+"%\n"
		index+=1
	index = 0
	for i in enem:
		if i != 0:
			if index != 0:
				if i > 0:
					m_text += " "+enem_desc[index]+" +"+str(enem[index])+"%\n"
				else:
					m_text += " "+enem_desc[index]+" "+str(enem[index])+"%\n"
			else:
				if i > 0:
					m_text += " "+enem_desc[index]+" +"+str(enem[index])+"\n"
				else:
					m_text += " "+enem_desc[index]+" "+str(enem[index])+"\n"
		index+=1
	index = 0
	for i in loot:
		if i != 0:
			if i>0:
				l_text += " "+loot_desc[index]+" +"+str(loot[index])+"%\n"
			else:
				l_text += " "+loot_desc[index]+" "+str(loot[index])+"%\n"
		index+=1
	index = 0
	for i in spec_feat:
		if i != 0:
			sf_text += " "+spec_feat_desc[index]+" +"+str(spec_feat[index])+"\n"
		index+=1
	$"../ScrollContainer2/VBoxContainer/affinity".text = a_text
	$"../ScrollContainer2/VBoxContainer/environment".text = e_text
	$"../ScrollContainer2/VBoxContainer/enemies".text = m_text
	$"../ScrollContainer2/VBoxContainer/loot".text = l_text
	$"../ScrollContainer2/VBoxContainer/special_features".text = sf_text


func load_data_to_dungeon():
	if preset_data != null:
		change_data(offset_values,false)
		change_data(preset_data,true)
		if preset_data.Boss_Enemy != null:
			DungeonData.boss = preset_data.Boss_Enemy
		if preset_data.Final_Floor != null:
			DungeonData.final_floor_layout = preset_data.Final_Floor
		if preset_data.Safe_Room_Floor != null:
			DungeonData.safe_room_floor_layout = preset_data.Safe_Room_Floor
		if preset_data.Mini_Bosses != null:
			DungeonData.mini_bosses = preset_data.Mini_Bosses
	#var dun_data = DUNGEON_CRAFTING_TILE_DATA.new()
	DungeonData.crafting_tier = get_parent().grid_level
	DungeonData.Affinity_Fire = Affinity_Fire
	DungeonData.Affinity_Water = Affinity_Water
	DungeonData.Affinity_Earth = Affinity_Earth
	DungeonData.Affinity_Air = Affinity_Air
	DungeonData.Affinity_Force = Affinity_Force
	DungeonData.Affinity_Light = Affinity_Light
	DungeonData.Affinity_Dark= Affinity_Dark 

	DungeonData.Biome_Test =Biome_Test 
	DungeonData.Biome_Volcano= Biome_Volcano 
	DungeonData.Biome_Island =Biome_Island
	DungeonData.Biome_Mesa =Biome_Mesa
	DungeonData.Biome_Skyland =Biome_Skyland

	DungeonData.EnvFeature_River= EnvFeature_River
	DungeonData.EnvFeature_Lake =EnvFeature_Lake 
	DungeonData.EnvFeature_Flooded =EnvFeature_Flooded 
	DungeonData.EnvFeature_Barren= EnvFeature_Barren

	DungeonData.Halls_DeadEnds = Halls_DeadEnds
	DungeonData.Rooms_Round =Rooms_Round 
	DungeonData.Rooms_DenseLayout =Rooms_DenseLayout 
	DungeonData.Rooms_SparceLayout =Rooms_SparceLayout
	DungeonData.Rooms_AlternatingSize= Rooms_AlternatingSize
	DungeonData.Rooms_Small= Rooms_Small
	DungeonData.Rooms_Large =Rooms_Large 

	DungeonData.ItemType_Gold =ItemType_Gold
	DungeonData.ItemType_Tiles= ItemType_Tiles 
	DungeonData.ItemType_Consumable= ItemType_Consumable
	DungeonData.ItemType_Gear =ItemType_Gear
	DungeonData.ItemType_Lockboxes= ItemType_Lockboxes 
	DungeonData.ItemType_KeyItem =ItemType_KeyItem 

	DungeonData.ItemMods_SpawnRate =ItemMods_SpawnRate 

	DungeonData.GearType_Weapon =GearType_Weapon
	DungeonData.GearType_Armour =GearType_Armour
	DungeonData.GearType_Trinket =GearType_Trinket

	DungeonData.Class_Vanguard =Class_Vanguard 
	DungeonData.Class_Warrior =Class_Warrior
	DungeonData.Class_Mage =Class_Mage
	DungeonData.Class_Rogue =Class_Rogue
	DungeonData.Class_Healer = Class_Healer
	DungeonData.Class_Jester = Class_Jester

	DungeonData.MobType_Beast =MobType_Beast
	DungeonData.MobType_Elemental =MobType_Elemental
	DungeonData.MobType_Undead =MobType_Undead 
	DungeonData.MobType_Construct =MobType_Construct
	DungeonData.MobType_Mortal =MobType_Mortal
	DungeonData.MobType_Wildling =MobType_Wildling

	DungeonData.MobMods_SpawnRate =MobMods_SpawnRate
	DungeonData.MobMods_Level =MobMods_Level
	DungeonData.MobMods_EXP =MobMods_EXP
	DungeonData.MobMods_Gold =MobMods_Gold
	DungeonData.MobMods_Gear =MobMods_Gear

	DungeonData.UniqueRooms_TreasureVault= UniqueRooms_TreasureVault
	DungeonData.UniqueRooms_MonsterHouse= UniqueRooms_MonsterHouse

	DungeonData.Boss_T0_Roaming =Boss_T0_Roaming
	DungeonData.Boss_T0_Mini =Boss_T0_Mini
	DungeonData.Boss_T1_Generic =Boss_T1_Generic
	DungeonData.Boss_T1_Fire =Boss_T1_Fire
	DungeonData.Boss_T1_Water= Boss_T1_Water
	DungeonData.Boss_T1_Earth =Boss_T1_Earth
	DungeonData.Boss_T1_Wind= Boss_T1_Wind
	DungeonData.Boss_T1_Force=Boss_T1_Force
	DungeonData.Boss_T2_Generic =Boss_T2_Generic
	DungeonData.Boss_T2_QuadElement =Boss_T2_QuadElement
	DungeonData.Boss_T2_Force =Boss_T2_Force
	
	DungeonData.extra_floors = extra_floors
	DungeonData.has_boss = has_boss
