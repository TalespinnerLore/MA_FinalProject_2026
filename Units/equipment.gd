extends Node
class_name Unit_Equipment_Inventory

@export var equipped_weapon:ItemData
@export var equipped_armour:ItemData
@export var equipped_trinket:ItemData
@export var trinket_slot_stacksize:= 0

@onready var unit:Unit_Instance = get_parent()

var enemy_must_drop_list:= []
#var enemy_gold_drop_amount:int = 0 ##this just becomes trinket stacksize, doi.

enum SOURCE{GROUND,INVENTORY}

func Attempt_Equip_to_Unit(Item:ItemData,ItemSource:SOURCE,Item_stacks:int):
	
	var success = true
	var equipped_item
	var unequip_stacksize = trinket_slot_stacksize
	match Item.GearType:
		Item.GEAR_TYPE.ARMOUR:
			equipped_item = equipped_armour
			if equipped_item == null:
				print('no equipped armour.')
			else:
				print("swapping out armour - ",equipped_item.ItemName)
		Item.GEAR_TYPE.WEAPON:
			equipped_item = equipped_weapon
			if equipped_item == null:
				print('no equipped weapon.')
			else:
				print("swapping out weapon - ",equipped_item.ItemName)
		Item.GEAR_TYPE.TRINKET:
			equipped_item = equipped_trinket
			if equipped_item == null:
				print('no equipped trinket.')
			else:
				print("swapping out trinket - ",equipped_item.ItemName)
		Item.GEAR_TYPE.N_A:
			equipped_item = equipped_trinket
			if equipped_item == null:
				print('no equipped misc item.')
			else:
				print("swapping out misc item - ",equipped_item.ItemName)
	
	print("check for equip attempt")
	if check_has_equip_stats(Item):
		print("meets stat conditions")
		if unit.Team == unit.Teams.PLAYER:
			print("is player unit")
			match ItemSource:
				SOURCE.GROUND:
					if PlayerStats.player_inventory.size() < PlayerStats.inventory_size:
						if equipped_item != null:
							#PlayerStats.player_inventory.append([equipped_item,1])
							if equipped_item != null:
								apply_gear_statboosts(equipped_item,false)
							add_to_equip_slot(Item)
							success = true
							if Item.GearType == Item.GEAR_TYPE.N_A:
								trinket_slot_stacksize = Item_stacks
								return [success,equipped_item,unequip_stacksize]
							else:
								return [success,equipped_item,1]
					else:
						print("Inventory is too full to unequip!")
						success = false
				SOURCE.INVENTORY:
					#PlayerStats.player_inventory.erase([Item,1])
					#PlayerStats.PlayerStats.player_inventory.append([equipped_item,1])
					print('is being equipped from inventory')
					#PlayerStats.EquipGear_Player(Item,0)
					if equipped_item != null:
						apply_gear_statboosts(equipped_item,false)
					add_to_equip_slot(Item)
					
					success = true
					if Item.GearType == Item.GEAR_TYPE.N_A:
						print('item is not gear')
						trinket_slot_stacksize = Item_stacks
						return [success,equipped_item,unequip_stacksize]
					else:
						return [success,equipped_item,1]
		elif unit.Team == unit.Teams.ENEMY:
			print("is enemy unit") #enemies only pick items up if they have an empty slot for it
			match ItemSource:		#and they never replace picked up items.
				SOURCE.GROUND:
					if equipped_item == null:
						add_to_equip_slot(Item)
						match Item.GearType:
							Item.GEAR_TYPE.ARMOUR:
								enemy_must_drop_list.append([Item,Item_stacks])
							Item.GEAR_TYPE.WEAPON:
								enemy_must_drop_list.append([Item,Item_stacks])
							Item.GEAR_TYPE.TRINKET:
								enemy_must_drop_list.append([Item,Item_stacks])
							Item.GEAR_TYPE.N_A:
								enemy_must_drop_list.append([Item,Item_stacks])
						success = true
					else:
						success = false
					return [success,null,0]
			pass
			
	else:
		print("Not enought stats to equip this!")
		success = false
	return [success,null,0]

func add_to_equip_slot(Item:ItemData):
	match Item.GearType:
		Item.GEAR_TYPE.ARMOUR:
			equipped_armour = Item
			unit.ABILITIES.ArmourAbility = Item.ItemAbility
			apply_gear_statboosts(Item,true)
		Item.GEAR_TYPE.WEAPON:
			equipped_weapon = Item
			unit.ABILITIES.WeaponAbility = Item.ItemAbility
			apply_gear_statboosts(Item,true)
		Item.GEAR_TYPE.TRINKET:
			equipped_trinket = Item
			unit.ABILITIES.TrinketAbility = Item.ItemAbility
			apply_gear_statboosts(Item,true)
		Item.GEAR_TYPE.N_A:
			equipped_trinket = Item
			unit.ABILITIES.TrinketAbility = Item.ItemAbility

func apply_gear_statboosts(data:ItemData_Gear, adding:bool):
	var is_equipping = 1
	if ! adding:
		is_equipping = -1
	unit.STR_boost += is_equipping*data.STR_boost
	unit.DEX_boost += is_equipping*data.DEX_boost
	unit.VIT_boost += is_equipping*data.VIT_boost
	unit.MAG_boost += is_equipping*data.MAG_boost
	unit.DEF_boost += is_equipping*data.DEF_boost
	unit.LUK_boost += is_equipping*data.LUK_boost
	print("boosted stats added!")

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

func on_spawn_apply_boosts():
	if equipped_trinket is ItemData_Gear and equipped_trinket != null:
		apply_gear_statboosts(equipped_trinket,true)
	if equipped_armour != null:
		apply_gear_statboosts(equipped_armour,true)
	if equipped_weapon != null:
		apply_gear_statboosts(equipped_weapon,true)
