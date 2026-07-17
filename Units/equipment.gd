extends Node
class_name Unit_Equipment_Inventory

@export var equipped_weapon:ItemData
@export var equipped_armour:ItemData
@export var equipped_trinket:ItemData

@onready var unit:Unit_Instance = get_parent()

enum SOURCE{GROUND,INVENTORY}

func Attempt_Equip_to_Unit(Item:ItemData,ItemSource:SOURCE):
	var success = true
	var equipped_item
	match Item.GearType:
		Item.GEAR_TYPE.ARMOUR:
			equipped_item = equipped_armour
		Item.GEAR_TYPE.WEAPON:
			equipped_item = equipped_weapon
		Item.GEAR_TYPE.TRINKET:
			equipped_item = equipped_trinket
		Item.GEAR_TYPE.N_A:
			equipped_item = equipped_trinket
	print("check for equip attempt")
	if check_has_equip_stats(Item):
		print("meets stat conditions")
		if unit.Team == unit.Teams.PLAYER:
			print("is player unit")
			match ItemSource:
				#SOURCE.GROUND:
				#	if PlayerStats.player_inventory.size() < PlayerStats.inventory_size:
				#		if equipped_item != null:
				#			PlayerStats.player_inventory.append([equipped_item,1])
				#		match Item.GearType:
				#			Item.GEAR_TYPE.ARMOUR:
				#				equipped_armour = Item
				#			Item.GEAR_TYPE.WEAPON:
				#				equipped_weapon = Item
				#			Item.GEAR_TYPE.TRINKET:
				#				equipped_trinket = Item
				#			Item.GEAR_TYPE.N_A:
				#				equipped_trinket = Item
				#	else:
				#		print("Inventory is too full to unequip!")
				#		success = false
				SOURCE.INVENTORY:
					#PlayerStats.player_inventory.erase([Item,1])
					#PlayerStats.PlayerStats.player_inventory.append([equipped_item,1])
					
					PlayerStats.EquipGear_Player(Item,0)
					match Item.GearType:
						Item.GEAR_TYPE.ARMOUR:
							equipped_armour = Item
						Item.GEAR_TYPE.WEAPON:
							equipped_weapon = Item
						Item.GEAR_TYPE.TRINKET:
							equipped_trinket = Item
						Item.GEAR_TYPE.N_A:
							equipped_trinket = Item
					success = true
			
	else:
		print("Not enought stats to equip this!")
		success = false
	return success

func add_to_equip_slot(Item:ItemData):
	match Item.GearType:
		Item.GEAR_TYPE.ARMOUR:
			equipped_armour = Item
			unit.ABILITIES.ArmourAbility = Item.ItemAbility
		Item.GEAR_TYPE.WEAPON:
			equipped_weapon = Item
			unit.ABILITIES.WeaponAbility = Item.ItemAbility
		Item.GEAR_TYPE.TRINKET:
			equipped_trinket = Item
			unit.ABILITIES.TrinketAbility = Item.ItemAbility
		Item.GEAR_TYPE.N_A:
			equipped_trinket = Item
			unit.ABILITIES.TrinketAbility = Item.ItemAbility




func check_has_equip_stats(Item:ItemData):
	if Item.STR_NEEDED <= (unit.STR+unit.STR_boost) \
	and Item.DEX_NEEDED <= (unit.DEX+unit.DEX_boost) \
	and Item.VIT_NEEDED <= (unit.VIT+unit.VIT_boost) \
	and Item.MAG_NEEDED <= (unit.MAG+unit.MAG_boost) \
	and Item.DEF_NEEDED <= (unit.DEF+unit.DEF_boost) \
	and Item.LUK_NEEDED <= (unit.LUK+unit.LUK_boost):
		return true
	else:
		return false

func drop_item_on_floor_NOTinUSE(Item:ItemData):
	pass #unnneeded
