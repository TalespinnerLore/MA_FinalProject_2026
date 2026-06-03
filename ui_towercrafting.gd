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
["RIVER",4],["LAKE",0],["ROUND_ROOMS",4],["DENSE_LAYOUT",2],["SPARSE_LAYOUT",2],["ALTERNATING_SIZE_ROOMS",0],["SMALL_ROOMS",2],["LARGE_ROOMS",2],\
["CONSUMABLES",2],["GEAR",0],["LOCKBOXES",0],["WEAPONS",0],["ARMOUR",0],["TRINKETS",0],\
["VANGUARD",0],["WARRIOR",0],["MAGE",0],["ROGUE",0],["HEALER",0],["JESTER",0],\
["INCREASED_MOB_DENSITY",0],["INCREASED_GOLD",2],["INCREASED_XP",0],["DECREASED_MOB_DENSITY",0],["DECREASED_GOLD",0],["DECREASED_XP",0],\
["BEASTS",0],["ELEMENTALS",0],["UNDEAD",0],["CONSTRUCTS",0],["MORTALS",0],["WILDLINGS",0],\
["TREASURE_ROOM",0],["MINI_BOSS",1],["MONSTER_HOUSE",1],\
["T1_BOSS",0],["T1_FIREBOSS",0],["T1_WATERBOSS",0],["T1_EARTHBOSS",0],["T1_AIRBOSS",0],["T1_FORCEBOSS",0],\
["T2_BOSS",0],["T2_QUADBOSS",0],["T2_FORCEBOSS",0]]

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
			tile.TILE_ID = ID_index
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
	populate_inventory_named()
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
	change_page(true)
	modifier_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed_left() -> void:
	change_page(false)

func _on_button_pressed_right() -> void:
	change_page(true)

func _on_button_start_pressed() -> void:
	print("testing button")
	DungeonData.Affinity = Affinity
	DungeonData.Enemies = Enemies
	DungeonData.Environments = Environments
	DungeonData.Loot = Loot
	DungeonData.Special_Features = Special_Features
	DungeonData.choose_biome()
	DungeonData.open_level()
	
	pass # Replace with function body.





func print_mods():
	var pastethis = ''
	for key in $"../ButtonSTART/TileObject".Tile_Crafting_Mods.keys():
		pastethis+=('["'+str(key)+'",0],')
	print(pastethis)
