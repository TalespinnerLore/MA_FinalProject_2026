extends Node

@export var BasicAttack:AbilityData= load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")

@export var Slot_1:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var Slot_2:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var Slot_3:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var Slot_4:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")

@export var WeaponAbility:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var ArmourAbility:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var TrinketAbility:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")


func init():
	BasicAttack = get_parent().UnitStats.BasicAttack
	pass
