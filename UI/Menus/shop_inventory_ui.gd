extends Control
class_name ShopInventoryUI

@export var inv_page = 0
var inv_page_max_items = 10
var tile_pages_max = 3
@export var tile_page = 0
var inv_content = PlayerStats.player_inventory
@onready var inv_container = $InventoryBox/ItemContainer
#@onready var ItemManager:GroundItemManager = $"../../GroundItem_Manager"
@export var selected_item:ItemData
@export var selected_inv_slot:= 0
@export var selected_item_stacks := 1

#@onready var unit_manager_ref:Unit_Manager =  get_tree().get_first_node_in_group("UNIT_MANAGER")
#var player:Unit_Instance

var weapon_icon = preload("res://Art/UI_Art/ui_icon_weapon.png")
var armour_icon = preload("res://Art/UI_Art/ui_icon_armour.png")
var trinket_icon = preload("res://Art/UI_Art/ui_icon_trinket.png")

var edible_icon = preload("res://Art/UI_Art/ui_icon_edible.png")
var throwing_icon = preload("res://Art/UI_Art/ui_icon_other.png")
var key_icon = preload("res://Art/UI_Art/ui_icon_key.png")
var other_icon = preload("res://Art/UI_Art/ui_icon_other.png")

var lockbox_icon = preload("res://Art/UI_Art/ui_icon_lockbox.png")
var key_item_icon = preload("res://Art/UI_Art/ui_icon_keyitem.png")

func _player_interaction():
	pause_level()
	open_close()

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	#unit_manager_ref = get_tree().get_first_node_in_group("UNIT_MANAGER")
	#player = unit_manager_ref.get_child(0).get_child(0)
	load_initial_shop_inventory()
	on_item_selected(selected_item)
	_on_left_button_pressed()
	load_item_inventory()
	#open_close()

func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("Inventory"):
#		open_close()
	pass

var gold_val := 0

func open_close():
	load_item_inventory()
	if inv_content.size() > 0:
		selected_item = inv_content[0][0]
		selected_inv_slot = 0
	else:
		selected_item = load("res://Resources/Items/Other/Gold.tres")
		selected_inv_slot = 0
	self.visible = ! self.visible
	pause_level()

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused

func load_values():
	print('hit load values')
	gold_val = PlayerStats.player_gold
	#print('gold:',gold_val,' ',str(gold_val))
	$GoldCounter/GoldAmountLabel.text = str('GOLD\n','\n',gold_val)
	#if tile_page == 0:
	var shopname:String
	match ShopType:
		0:
			shopname = 'CONSUMABLE'
		1:
			shopname = 'GEAR'
		2:
			shopname = 'TOWER TILE'
	#print(str(shopname," SHOP Pg. ",inv_page))
	$InventoryBox/InventoryLabel.text = str(shopname," SHOP Pg. ",inv_page+1)
	#else:
	#	$InventoryBox/InventoryLabel.text = str("TILE INVENTORY Pg. ",tile_page)


func load_item_inventory():
	for i in range(0,4): #hides all pages
		$InventoryBox.get_child(i).visible = false
	inv_container.visible = true
	inv_content = PlayerStats.player_inventory
	print('invcontent:',shop_inv,' count:',shop_inv.size())
	shop_inv.sort()
	var index = 0
	for item in inv_container.get_children():
		if (inv_page*inv_page_max_items)+index > shop_inv.size() - 1:
			item.visible = false
		else:
			item.visible = true
			var data = shop_inv[(inv_page*inv_page_max_items)+index][0] #ItemData
			print('itemdata:',data)
			var stack_count = shop_inv[(inv_page*inv_page_max_items)+index][1] #stack_size
			item.icon = get_item_icon(data)
			item.text = data.ItemName
			if data.max_stack > 1:
				item.get_child(0).visible = true
				item.get_child(0).text = str("[",stack_count,"/",data.max_stack,"]")
			else:
				item.get_child(0).visible = false
		index+=1
	load_values()

func get_item_icon(data:ItemData):
	if data.GearType != ItemData.GEAR_TYPE.N_A:
		match data.GearType:
			ItemData.GEAR_TYPE.ARMOUR:
				return weapon_icon
			ItemData.GEAR_TYPE.WEAPON:
				return armour_icon
			ItemData.GEAR_TYPE.TRINKET:
				return trinket_icon
	elif data.ConsType != ItemData.CONS_TYPE.N_A:
		match data.ConsType:
			ItemData.CONS_TYPE.EDIBLE:
				return edible_icon
			ItemData.CONS_TYPE.THROWING:
				return throwing_icon
			ItemData.CONS_TYPE.KEY:
				return key_icon
			ItemData.CONS_TYPE.OTHER:
				return other_icon
	else:
		match data.ItemType:
			ItemData.ITEM_TYPE.LOCKBOX:
				return lockbox_icon
			ItemData.ITEM_TYPE.KEY_ITEM:
				return key_item_icon
	#enum ITEM_TYPE {GOLD,TILE,CONSUMABLE,GEAR,LOCKBOX,KEY_ITEM}
	pass

func load_tile_inventory():
	for i in range(0,4):
		$InventoryBox.get_child(i).visible = false
	$InventoryBox.get_child(tile_page).visible = true
	pass


func _on_left_button_pressed() -> void:
	print('HITS LEFT BUTTON PRSSED')
	if inv_page > 0:#and tile_page < 1:
		inv_page -= 1
		load_item_inventory()
		$InventoryBox/RightButton/NextLabel.text = str(inv_page+2)
		if inv_page == 0:
			$InventoryBox/LeftButton/BackLabel.text = "x"#str("T",tile_pages_max)
		else:
			$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
	#else:
	#	tile_page = clampi(tile_page-1,0,3)
	#	if tile_page == 0:
	#		load_item_inventory()
	#		if inv_page == 0:
	#			$InventoryBox/LeftButton/BackLabel.text = ""
	#		else:
	#			$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
	#		$InventoryBox/RightButton/NextLabel.text = str("T",1)
	#	else:
	#		load_tile_inventory()
	#		if tile_page == 1:
	#			$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
	#		else:
	#			$InventoryBox/LeftButton/BackLabel.text = str("T",tile_page-1)
	#		$InventoryBox/RightButton/NextLabel.text = str("T",tile_page+1)
	load_values()
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	print('max pages:size;',shop_inv.size(),' ',ceil(shop_inv.size()/10))
	if inv_page < ceil(shop_inv.size()/10):
		inv_page = clampi(inv_page + 1,0,ceil(shop_inv.size()/10))
		load_item_inventory()
		$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
		#if inv_page == int(inv_content.size()/10)-1:
		#	$InventoryBox/LeftButton/NextLabel.text = str("T",1)
			
		#else:
		$InventoryBox/RightButton/NextLabel.text = str(inv_page+2)
	#elif tile_page < 3:
	#	tile_page += 1
	#	load_tile_inventory()
	#	if tile_page < 3:
	#		$InventoryBox/RightButton/NextLabel.text = str("T",tile_page+1)
	#	else:
	#		$InventoryBox/RightButton/NextLabel.text = ''
	#	$InventoryBox/LeftButton/BackLabel.text = str("T",tile_page-1)
	#	if tile_page == 1:
	#		$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
	load_values()
	pass #tileinventorybox not implemented yet


func on_item_selected(data:ItemData):
	
	selected_item_stacks = shop_inv[selected_inv_slot][1]
	selected_item = data
	item_cost = data.shop_value * selected_item_stacks
	$GoldCounter2/GoldAmountLabel.text = str('COST\n','\n',item_cost)
	#print(data)
	$ShowItemBox/TextureRect.texture = data.icon
	$ShowItemBox/NameLabel.text = data.ItemName #=====================\n
	$DescriptionBox/StatReqLabel.text = str('Stat Requirements:\nSTR - ',data.STR_NEEDED,\
	'\nDEX - ',data.DEX_NEEDED,'\nVIT - ',data.VIT_NEEDED,'\nMAG - ',data.MAG_NEEDED,\
	'\nDEF - ',data.DEF_NEEDED,'\nLUK - ',data.LUK_NEEDED,)#'\n=====================')
	$DescriptionBox/DescriptionLabel.text = str(data.DESCRIPTION,'\n',#'==================================\n',
	'\n',
	'Rarity:',data.rarity,' Itemtype: ',data.ItemType,'\n',
	'\n',
	#'Gear/Consumable subtype\n',
	#5 I SHOULD HAVE MADE RESOURCE SUBTYPE FUUUUUUUCK
	#6 \add affinity text here at some point
	)


func _on_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	selected_inv_slot = 10*inv_page + 0
	on_item_selected(shop_inv[10*inv_page + 0][0])
	
func _on_button_2_pressed() -> void:
	selected_inv_slot = 10*inv_page + 1
	on_item_selected(shop_inv[10*inv_page + 1][0])

func _on_button_3_pressed() -> void:
	selected_inv_slot = 10*inv_page + 2
	on_item_selected(shop_inv[10*inv_page + 2][0])

func _on_button_4_pressed() -> void:
	selected_inv_slot = 10*inv_page + 3
	on_item_selected(shop_inv[10*inv_page + 3][0])

func _on_button_5_pressed() -> void:
	selected_inv_slot = 10*inv_page + 4
	on_item_selected(shop_inv[10*inv_page + 4][0])

func _on_button_6_pressed() -> void:
	selected_inv_slot = 10*inv_page + 5
	on_item_selected(shop_inv[10*inv_page + 5][0])

func _on_button_7_pressed() -> void:
	selected_inv_slot = 10*inv_page + 6
	on_item_selected(shop_inv[10*inv_page + 6][0])

func _on_button_8_pressed() -> void:
	selected_inv_slot = 10*inv_page + 7
	on_item_selected(shop_inv[10*inv_page + 7][0])

func _on_button_9_pressed() -> void:
	selected_inv_slot = 10*inv_page + 8
	on_item_selected(shop_inv[10*inv_page + 8][0])

func _on_button_10_pressed() -> void:
	selected_inv_slot = 10*inv_page + 9
	on_item_selected(shop_inv[10*inv_page + 9][0])


@onready var Items_Consumable:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Consumables.tres")
@onready var Items_Gear:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Gear.tres")
@onready var Items_Tiles:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Tiles.tres")

enum SHOPS{CONSUMABLES,GEAR,TILES}
@export var ShopType:SHOPS



var player_level:int
var itemcount_b:= 10
var itemcount_r: = 5
var itemcount_e: = 0
var itemcount_u: = 0

var shop_inv = []#[ItemData,stack] 
var item_cost := 1

func load_initial_shop_inventory():
	player_level = PlayerStats.p1_level
	itemcount_b = 5 + 3*int(player_level/5)
	itemcount_r = 3 + 1*int(player_level/5)
	itemcount_e = 0 + 1*int(player_level/10)
	itemcount_u = 0 + 1*int(player_level/20)
	print('breu; ',itemcount_b,' ',itemcount_r,' ',itemcount_e,' ',itemcount_u,' ')
	var items = []
	var items_basic = []
	var items_rare = []
	var items_elite = []
	var items_unique = []
	match ShopType:
		SHOPS.CONSUMABLES:
			Items_Consumable.load_all_into(items)
		SHOPS.GEAR:
			Items_Gear.load_all_into(items)
		SHOPS.TILES:
			Items_Tiles.load_all_into(items)
	#sort into level range
	var sorted_things = []
	for thing:ItemData in items:
		if thing.min_area_level > player_level or thing.max_area_level < player_level:
			pass #this brained easier, sue me.
		else:
			sorted_things.append(thing)
	items = sorted_things
	#sort into rarities
	for thing:ItemData in items:
		match thing.rarity:
			0: #BASIC
				items_basic.append(thing)
			1: #RARE
				items_rare.append(thing)
			2: #ELITE
				items_elite.append(thing)
			3: #UNIQUE
				items_unique.append(thing)
	if itemcount_b > 0 and items_basic.size() > 0: #dont want this to break for no reason...
		for i in range(0,itemcount_b):
			var add:ItemData = items_basic.pick_random()
			shop_inv.append([add, randi_range(1,add.max_stack)])
	if itemcount_r > 0 and items_rare.size() > 0:
		for i in range(0,itemcount_r):
			var add:ItemData = items_rare.pick_random()
			shop_inv.append([add, randi_range(1,add.max_stack)])
	if itemcount_e > 0 and items_elite.size() > 0:
		for i in range(0,itemcount_e):
			var add:ItemData = items_elite.pick_random()
			shop_inv.append([add, randi_range(1,add.max_stack)])
	if itemcount_u > 0 and items_unique.size() > 0:
		for i in range(0,itemcount_u):
			var add:ItemData = items_unique.pick_random()
			shop_inv.append([add, randi_range(1,add.max_stack)])
	pass

func add_to_tile_inv(TILE_ID):
	SaveLoad.SaveFileData.TileID_NamedInventory[TILE_ID][1] += 1
	pass

func _on_buy_button_pressed() -> void:
	if selected_item.ItemName == 'Gold':
		return
	if selected_item.ItemType == 1:
		if item_cost <= PlayerStats.player_gold:
			add_to_tile_inv(selected_item.TILE_ID)
		else:
			print("You can't afford that.")
		return
	if inv_content.size() < PlayerStats.inventory_size and item_cost <= PlayerStats.player_gold:
		var success_remainder = PlayerStats.Add_to_Player_Inv_stack(selected_item,selected_item_stacks)
		PlayerStats.player_gold -= item_cost
		shop_inv.pop_at(selected_inv_slot)
		load_item_inventory()
	elif item_cost <= PlayerStats.player_gold:
		var spare_stacks = 0
		for item in inv_content:
			if item[0].ItemName == selected_item.ItemName:
				spare_stacks += (item[0].max_stack - item[1])
		if selected_item_stacks <= spare_stacks:
			for i in range(0,selected_item_stacks):
				var success_remainder = PlayerStats.Add_to_Player_Inv_stack(selected_item,selected_item_stacks)
				if success_remainder[1] <= 0: #for if they all fit in one stack without remainder
					break
			PlayerStats.player_gold -= item_cost
			shop_inv.pop_at(selected_inv_slot)
			load_item_inventory()
		else:
			print('full inventory; doesnt fit.')
	else:
		print("You can't afford that.")
	pass # Replace with function body.


func _on_texture_button_pressed() -> void:
	pause_level()
	open_close()
