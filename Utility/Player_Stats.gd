extends Node


var p1_class:StatComponent = load("res://Resources/Units/Player/Stats_Warrior.tres")
var p1_weapon:ItemData
var p1_armour:ItemData
var p1_trinket:ItemData
var p1_equipped_abilities:Array[AbilityData] = [load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")]
var p1_ability_uses1234WAT:Array[int] = [0,0,0,0,0,0,0] #1234WAT
var p1_HP:int
var p1_investedStrDexVitMagDefLuk:Array[int] = [0,0,0,0,0,0]
var p1_free_stats := 0
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
var player_gold = 0

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
	success = false
	return [success,remaining_stack]
