extends Node


var p1_class:StatComponent = load("res://Resources/Units/Player/Stats_Warrior.tres")
var p1_weapon:Resource
var p1_armour:Resource
var p1_trinket:Resource
var p1_equipped_abilities:Array[AbilityData] = [load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")]

var p2_class:StatComponent
var p2_weapon:Resource
var p2_armour:Resource
var p2_trinket:Resource
var p2_equipped_abilities:Array[AbilityData] = [load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres"),load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")]

var player_inventory = [] #[ITEM_ID,AMOUNT]
var inventory_size = 10
var player_gold = 0
