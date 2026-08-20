extends Control
class_name LOCKBOX_ui

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _on_texture_button_pressed() -> void:
	pause_level()
	open_close()

func _player_interaction():
	pause_level()
	open_close()

func open_close():
	set_buttons()
	#load_item_inventory()
	#if inv_content.size() > 0:
	#	selected_item = inv_content[0][0]
	#	selected_inv_slot = 0
	#else:
	#	selected_item = load("res://Resources/Items/Other/Gold.tres")
	#	selected_inv_slot = 0
	self.visible = ! self.visible
	pause_level()

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused

@onready var Items_Consumable:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Consumables.tres")
@onready var Items_Gear:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Gear.tres")
@onready var Items_Tiles:ResourceGroup = load("res://Resources/_Resource_x_Groups/Items_Tiles.tres")

var count0 = 0
var count1 = 0
var count2 = 0
var count3 = 0

func set_buttons():
	count0 = 0
	count1 = 0
	count2 = 0
	count3 = 0
	for item in PlayerStats.player_inventory:
		if item == [load("res://Resources/Items/Lockboxes/Lockbox_Wood.tres"),1]:
			count0 += 1
		elif item == [load("res://Resources/Items/Lockboxes/Lockbox_Copper.tres"),1]:
			count1 += 1
		elif item == [load("res://Resources/Items/Lockboxes/Lockbox_Silver.tres"),1]:
			count2 += 1
		elif item == [load("res://Resources/Items/Lockboxes/Lockbox_Gold.tres"),1]:
			count3 += 1
	$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer2/Label3.text = str(count0)
	$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer3/Label3.text = str(count1)
	$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer4/Label3.text = str(count2)
	$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer5/Label3.text = str(count3)
	if count0 <= 0:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer2/Button.disabled = true
	else:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer2/Button.disabled = false
	if count1 <= 0:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer3/Button.disabled = true
	else:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer3/Button.disabled = false
	if count2 <= 0:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer4/Button.disabled = true
	else:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer4/Button.disabled = false
	if count3 <= 0:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer5/Button.disabled = true
	else:
		$BackgroundTexture_9PR/InventoryBox/VBoxContainer/HBoxContainer5/Button.disabled = false

func get_item(boxtier:int):
	var items = []
	Items_Consumable.load_all_into(items)
	Items_Gear.load_all_into(items)
	Items_Tiles.load_all_into(items)
	var options = []
	var levellow = 0
	var levelhigh = 999
	for item:ItemData in items:
		match boxtier:
			0:
				levellow = 5
				levelhigh = 15
			1:
				levellow = 10
				levelhigh = 20
			2:
				levellow = 15
				levelhigh = 25
			3:
				levellow = 20
				levelhigh = 999
		if item.min_area_level >= levellow and item.max_area_level <= levelhigh:
			if item.rarity >= 2:
				options.append(item)
			if item.rarity < 3:
				options.append(item)
	if options.size() < 1:
		options.append(load("res://Resources/Items/Consumables/HealthPotion_Large.tres"))
	match boxtier:
			0:
				PlayerStats.player_inventory.erase([load("res://Resources/Items/Lockboxes/Lockbox_Wood.tres"),1])
			1:
				PlayerStats.player_inventory.erase([load("res://Resources/Items/Lockboxes/Lockbox_Copper.tres"),1])
			2:
				PlayerStats.player_inventory.erase([load("res://Resources/Items/Lockboxes/Lockbox_Silver.tres"),1])
			3:
				PlayerStats.player_inventory.erase([load("res://Resources/Items/Lockboxes/Lockbox_Gold.tres"),1])
	var pick = options.pick_random()
	PlayerStats.Add_to_Player_Inv_stack(pick,1)
	set_buttons()


func _on_button_pressed0() -> void:
	if PlayerStats.player_gold >= 250:
		PlayerStats.player_gold-=250
		get_item(0)


func _on_button_pressed1() -> void:
	if PlayerStats.player_gold >= 500:
		PlayerStats.player_gold-=500
		get_item(1)


func _on_button_pressed2() -> void:
	if PlayerStats.player_gold >=750:
		PlayerStats.player_gold-=750
		get_item(2)


func _on_button_pressed3() -> void:
	if PlayerStats.player_gold >= 1000:
		PlayerStats.player_gold-=1000
		get_item(3)
