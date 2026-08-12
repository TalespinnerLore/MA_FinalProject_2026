extends Node


var p1_class:StatComponent = load("res://Resources/Units/Player/Stats_Warrior.tres")
var p1_weapon:ItemData_Gear
var p1_armour:ItemData_Gear
var p1_trinket:ItemData
var p1_trinket_slot_stacksize:= 0
var p1_equipped_abilities:Array[AbilityData] = [load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")]
var p1_ability_usesB1234WAT:Array[int] = [999,0,0,0,0,0,0,0] #1234WAT
var p1_HP:int
var p1_level:=20
var p1_XP:=0
var p1_investedStrDexVitMagDefLuk:Array[int] = [0,0,0,0,0,0] 
var p1_free_stats := 5
#var p1_statuseffects:Array

var p2_class:StatComponent
var p2_weapon:ItemData
var p2_armour:ItemData
var p2_trinket:ItemData
var p2_equipped_abilities:Array[AbilityData] = [load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")]
var p2_HP:int
var p2_investedStrDexVitMagDefLuk:Array[int] = [0,0,0,0,0,0]
var p2_free_stats := 0
#var p2_statuseffects:Array

var player_inventory = [] #[ITEM_ID,AMOUNT]
var inventory_size = 10
var player_gold = 999

@export var TileID_NamedInventory = [["TEST",0],["FIRE",0],["WATER",0],["EARTH",0],["AIR",0],["FORCE",0],\
["VOLCANO",0],["ISLANDS",0],["MESA",0],["SKY_ISLANDS",0],\
["RIVER",0],["LAKE",0],["ROUND_ROOMS",0],["DENSE_LAYOUT",0],["SPARSE_LAYOUT",0],["ALTERNATING_SIZE_ROOMS",0],["SMALL_ROOMS",0],["LARGE_ROOMS",0],\
["CONSUMABLES",0],["GEAR",0],["LOCKBOXES",0],["WEAPONS",0],["ARMOUR",0],["TRINKETS",0],\
["VANGUARD",0],["WARRIOR",0],["MAGE",0],["ROGUE",0],["HEALER",0],["JESTER",0],\
["INCREASED_MOB_DENSITY",0],["INCREASED_GOLD",0],["INCREASED_XP",0],["DECREASED_MOB_DENSITY",0],["DECREASED_GOLD",0],["DECREASED_XP",0],\
["BEASTS",0],["ELEMENTALS",0],["UNDEAD",0],["CONSTRUCTS",0],["MORTALS",0],["WILDLINGS",0],\
["TREASURE_ROOM",0],["MINI_BOSS",0],["MONSTER_HOUSE",0],\
["T1_BOSS",0],["T1_FIREBOSS",0],["T1_WATERBOSS",0],["T1_EARTHBOSS",0],["T1_AIRBOSS",0],["T1_FORCEBOSS",0],\
["T2_BOSS",0],["T2_QUADBOSS",0],["T2_FORCEBOSS",0]]


func Add_to_Player_Inv_stack(Item:ItemData,stack_size:int):
	var success:=true
	var remaining_stack = stack_size
	for slot in player_inventory:
		if slot[0] == Item and slot[1] < Item.max_stack:
			var space = Item.max_stack-slot[1]
			if space >= remaining_stack:
				slot[1] += remaining_stack
				remaining_stack = 0
				return [success,remaining_stack]
			elif Item.max_stack > 1:
				slot[1] = Item.max_stack
				remaining_stack -= space
				return [success,remaining_stack]
			if player_inventory.size() < inventory_size and remaining_stack > 0:
				player_inventory.append([Item,remaining_stack])
				return [success,remaining_stack]
	if player_inventory.size() < inventory_size:
		print("adding to empty inventory slot")
		player_inventory.append([Item,stack_size])
		remaining_stack = 0
		return [success,remaining_stack]
	success = false
	return [success,remaining_stack]

func Remove_from_Player_Inv_stack(Item:ItemData,index:int):
	print(player_inventory)
	var success:=false
	#var remaining_stack = stack_size
	if player_inventory[index][0] == Item:
		print("removed ",Item.ItemName," from inventory")
		player_inventory.pop_at(index)
		success = true
		
	return success


func EquipGear_Player(data:ItemData,playerindex:int,stacksize:int): #VERIFY EQUIPABILITY IN UNIT
	var helddata:ItemData							#THIS IS ONLY FOR PLAYER INVENTORY
	var unequip_stack = 1
	match playerindex:
		0:
			match data.GearType:
				ItemData.GEAR_TYPE.ARMOUR:
					if p1_armour != null:
						helddata = p1_armour
					p1_armour = data
				ItemData.GEAR_TYPE.WEAPON:
					if p1_weapon != null:
						helddata = p1_weapon
					p1_weapon = data
				ItemData.GEAR_TYPE.TRINKET:
					if p1_trinket != null:
						helddata = p1_trinket
					p1_trinket = data
				ItemData.GEAR_TYPE.N_A:
					if p1_trinket != null:
						helddata = p1_trinket
						unequip_stack = p1_trinket_slot_stacksize
					p1_trinket = data
					p1_trinket_slot_stacksize = stacksize
			if helddata != null:
				#Add_to_Player_Inv_stack(helddata,unequip_stack)
				pass

func fill_ability_usesB1234WAT(playerindex,moveindex):
		match playerindex:
			0:
				match moveindex:
					0:
						p1_ability_usesB1234WAT[0] = 999
					1:
						p1_ability_usesB1234WAT[1] = p1_equipped_abilities[0].max_uses
					2:
						p1_ability_usesB1234WAT[2] = p1_equipped_abilities[1].max_uses
					3:
						p1_ability_usesB1234WAT[3] = p1_equipped_abilities[2].max_uses
					4:
						p1_ability_usesB1234WAT[4] = p1_equipped_abilities[3].max_uses
					5:
						if p1_weapon != null:
							p1_ability_usesB1234WAT[5] = p1_weapon.ItemAbility.max_uses
					6:
						if p1_armour != null:
							p1_ability_usesB1234WAT[6] = p1_armour.ItemAbility.max_uses
					7:
						if p1_trinket != null:
							p1_ability_usesB1234WAT[7] = p1_trinket.ItemAbility.max_uses
