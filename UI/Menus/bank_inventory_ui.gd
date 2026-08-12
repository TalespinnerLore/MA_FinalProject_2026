extends Control
class_name BankInventoryUI

@export var bank_inv_page = 0
var bank_inv_page_max_items = 10
var bank_inv_content = PlayerStats.player_inventory
@onready var bank_inv_container = $BankInventoryBox/ItemContainer
@export var bank_selected_item:ItemData
@export var bank_selected_inv_slot:= 0

@export var inv_page = 0
var inv_page_max_items = 10
var tile_pages_max = 3
@export var tile_page = 0
var inv_content = PlayerStats.player_inventory
@onready var inv_container = $InventoryBox/ItemContainer
@onready var ItemManager:GroundItemManager = $"../../GroundItem_Manager"
@export var selected_item:ItemData
@export var selected_inv_slot:= 0

@onready var unit_manager_ref:Unit_Manager =  get_tree().get_first_node_in_group("UNIT_MANAGER")
var player:Unit_Instance

var weapon_icon = preload("res://Art/UI_Art/ui_icon_weapon.png")
var armour_icon = preload("res://Art/UI_Art/ui_icon_armour.png")
var trinket_icon = preload("res://Art/UI_Art/ui_icon_trinket.png")

var edible_icon = preload("res://Art/UI_Art/ui_icon_edible.png")
var throwing_icon = preload("res://Art/UI_Art/ui_icon_other.png")
var key_icon = preload("res://Art/UI_Art/ui_icon_key.png")
var other_icon = preload("res://Art/UI_Art/ui_icon_other.png")

var lockbox_icon = preload("res://Art/UI_Art/ui_icon_lockbox.png")
var key_item_icon = preload("res://Art/UI_Art/ui_icon_keyitem.png")

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	unit_manager_ref = get_tree().get_first_node_in_group("UNIT_MANAGER")
	player = unit_manager_ref.get_child(0).get_child(0)
	on_item_selected(selected_item)
	_on_left_button_pressed()
	load_item_inventory()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		open_close()

var gold_val := 0
var bank_gold_val := 0

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
	gold_val = PlayerStats.player_gold
	$InventoryBox/GoldCounter/GoldAmountLabel.text = str(gold_val)
	if tile_page == 0:
		$InventoryBox/InventoryLabel.text = str("INVENTORY [",PlayerStats.player_inventory.size(),"/",PlayerStats.inventory_size,"] Pg. ",inv_page)
	else:
		$InventoryBox/InventoryLabel.text = str("TILE INVENTORY Pg. ",tile_page)

func bank_load_values():
	bank_gold_val = 0# PlayerStats.player_gold
	$GoldCounterBank/GoldAmountLabel.text = str(gold_val)
	$BankInventoryBox/InventoryLabel.text = str("BANK [",0,"/",999,"]")

func load_item_inventory():
	for i in range(0,4): #hides all pages
		$InventoryBox.get_child(i).visible = false
	inv_container.visible = true
	inv_content = PlayerStats.player_inventory
	print('invcontent:',inv_content)
	
	var index = 0
	for item in inv_container.get_children():
		if (inv_page*inv_page_max_items)+index > inv_content.size() - 1:
			item.visible = false
		else:
			item.visible = true
			var data = inv_content[(inv_page*inv_page_max_items)+index][0] #ItemData
			print('itemdata:',data)
			var stack_count = inv_content[(inv_page*inv_page_max_items)+index][1] #stack_size
			item.icon = get_item_icon(data)
			item.text = data.ItemName
			if data.max_stack > 1:
				item.get_child(0).visible = true
				item.get_child(0).text = str("[",stack_count,"/",data.max_stack,"]")
			else:
				item.get_child(0).visible = false
		index+=1

func bank_load_item_inventory():
	for i in range(0,4): #hides all pages
		$BankInventoryBox.get_child(i).visible = false
	bank_inv_container.visible = true
	bank_inv_content = []#PlayerStats.player_inventory
	print('invcontent:',bank_inv_content)
	
	var index = 0
	for item in bank_inv_container.get_children():
		if (bank_inv_page*bank_inv_page_max_items)+index > bank_inv_content.size() - 1:
			item.visible = false
		else:
			item.visible = true
			var data = bank_inv_content[(bank_inv_page*bank_inv_page_max_items)+index][0] #ItemData
			print('itemdata:',data)
			var stack_count = bank_inv_content[(bank_inv_page*bank_inv_page_max_items)+index][1] #stack_size
			item.icon = get_item_icon(data)
			item.text = data.ItemName
			if data.max_stack > 1:
				item.get_child(0).visible = true
				item.get_child(0).text = str("[",stack_count,"/",data.max_stack,"]")
			else:
				item.get_child(0).visible = false
		index+=1

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
	if inv_page > 0 and tile_page < 1:
		inv_page -= 1
		load_item_inventory()
		$InventoryBox/RightButton/NextLabel.text = str(inv_page+1)
		if inv_page == 0:
			$InventoryBox/LeftButton/BackLabel.text = ""#str("T",tile_pages_max)
		else:
			$InventoryBox/LeftButton/BackLabel.text = str(inv_page-1)
	else:
		tile_page = clampi(tile_page-1,0,3)
		if tile_page == 0:
			load_item_inventory()
			if inv_page == 0:
				$InventoryBox/LeftButton/BackLabel.text = ""
			else:
				$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
			$InventoryBox/RightButton/NextLabel.text = str("T",1)
		else:
			load_tile_inventory()
			if tile_page == 1:
				$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
			else:
				$InventoryBox/LeftButton/BackLabel.text = str("T",tile_page-1)
			$InventoryBox/RightButton/NextLabel.text = str("T",tile_page+1)
	load_values()
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	if inv_page < int(inv_content.size()/10)-1:
		inv_page = clampi(inv_page + 1,0,int(inv_content.size()/10)-1)
		load_item_inventory()
		$InventoryBox/LeftButton/BackLabel.text = str(inv_page-1)
		if inv_page == int(inv_content.size()/10)-1:
			$InventoryBox/LeftButton/NextLabel.text = str("T",1)
			
		else:
			$InventoryBox/LeftButton/NextLabel.text = str(inv_page+1)
	elif tile_page < 3:
		tile_page += 1
		load_tile_inventory()
		if tile_page < 3:
			$InventoryBox/RightButton/NextLabel.text = str("T",tile_page+1)
		else:
			$InventoryBox/RightButton/NextLabel.text = ''
		$InventoryBox/LeftButton/BackLabel.text = str("T",tile_page-1)
		if tile_page == 1:
			$InventoryBox/LeftButton/BackLabel.text = str(inv_page)
	load_values()
	pass #tileinventorybox not implemented yet


func on_item_selected(data:ItemData):
	selected_item = data
	print(data)
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

func bank_on_left_button_pressed() -> void:
	print('HITS LEFT BUTTON PRSSED')
	if bank_inv_page > 0:#and tile_page < 1:
		bank_inv_page -= 1
		load_item_inventory()
		$InventoryBox/RightButton/NextLabel.text = str(bank_inv_page+2)
		if bank_inv_page == 0:
			$InventoryBox/LeftButton/BackLabel.text = "x"#str("T",tile_pages_max)
		else:
			$InventoryBox/LeftButton/BackLabel.text = str(bank_inv_page)
	bank_load_values()
	pass # Replace with function body.


func bank_on_right_button_pressed() -> void:
	print('max pages:size;',bank_inv_content.size(),' ',ceil(bank_inv_content.size()/10))
	if bank_inv_page < ceil(bank_inv_content.size()/10):
		bank_inv_page = clampi(bank_inv_page + 1,0,ceil(bank_inv_content.size()/10))
		load_item_inventory()
		$InventoryBox/LeftButton/BackLabel.text = str(bank_inv_page)
		$InventoryBox/RightButton/NextLabel.text = str(bank_inv_page+2)
	bank_load_values()
	pass 

func _on_use_button_pressed() -> void:
	if selected_item.ConsType != ItemData.CONS_TYPE.N_A:
		player.ability_effect_calculations(selected_item.ItemAbility,player)
		PlayerStats.player_inventory[selected_inv_slot][1] -= 1
		if PlayerStats.player_inventory[selected_inv_slot][1] <= 0:
			PlayerStats.Remove_from_Player_Inv_stack(selected_item,selected_inv_slot)
		open_close()
	pass # Replace with function body.


func _on_give_button_pressed() -> void:
	if selected_item.ItemName != 'Gold':
		print("attempt equip")
		var equip_attemp_stack = PlayerStats.player_inventory[selected_inv_slot][1]
		var does_equip = player.EQUIPMENT.Attempt_Equip_to_Unit(selected_item, \
		player.EQUIPMENT.SOURCE.INVENTORY,equip_attemp_stack)
		#[success(bool), unequipped item(ItemData), stack_size(only not 1 if it was not gear)]
		print('sucess,item,stack; ',does_equip)
		if does_equip[0] == true:
			print('item DID equip; play inv:',PlayerStats.player_inventory)
			PlayerStats.Remove_from_Player_Inv_stack(selected_item,selected_inv_slot)
			if does_equip[1] != null:
				PlayerStats.Add_to_Player_Inv_stack(does_equip[1],does_equip[2])
			PlayerStats.EquipGear_Player(selected_item,0,equip_attemp_stack)
			inv_content = PlayerStats.player_inventory
		if inv_content.size() < 1:
			selected_item = load("res://Resources/Items/Other/Gold.tres")
			print(selected_item)
			selected_inv_slot = 0
			on_item_selected(selected_item)
		load_item_inventory()
		#if inv_content.size() = 0:
		#	selected_item = 
	#solve the issue of stcking consumables having the whole stack deleted later.
	##make stack amount = ability uses for the comsumable on the UI or something
	pass # Replace with function body.


func _on_drop_button_pressed() -> void:
	if selected_item.ItemName != 'Gold':
		var dropped = ItemManager.drop_item(player.self_coords+player.facing,selected_item,\
		PlayerStats.player_inventory[selected_inv_slot][1])

		
		if dropped:
			PlayerStats.Remove_from_Player_Inv_stack(selected_item,selected_inv_slot)
			load_item_inventory()
		else:
			print("There's no space to drop this!")
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 0][0])
	selected_inv_slot = 10*inv_page + 0
func _on_button_2_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 1][0])
	selected_inv_slot = 10*inv_page + 1
func _on_button_3_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 2][0])
	selected_inv_slot = 10*inv_page + 2
func _on_button_4_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 3][0])
	selected_inv_slot = 10*inv_page + 3
func _on_button_5_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 4][0])
	selected_inv_slot = 10*inv_page + 4
func _on_button_6_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 5][0])
	selected_inv_slot = 10*inv_page + 5
func _on_button_7_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 6][0])
	selected_inv_slot = 10*inv_page + 6
func _on_button_8_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 7][0])
	selected_inv_slot = 10*inv_page + 7
func _on_button_9_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 8][0])
	selected_inv_slot = 10*inv_page + 8
func _on_button_10_pressed() -> void:
	on_item_selected(inv_content[10*inv_page + 9][0])
	selected_inv_slot = 10*inv_page + 9
