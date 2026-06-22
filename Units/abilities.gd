extends Node
class_name unit_equipped_abilities

@export var BasicAttack:AbilityData= load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")

@export var Slot_1:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var Slot_2:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var Slot_3:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var Slot_4:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")

@export var WeaponAbility:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var ArmourAbility:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")
@export var TrinketAbility:AbilityData = load("res://Resources/Abilities/_basic_attacks/_DefaultBasicAttack.tres")

@export var ability_usesB1234WAT:Array[int] = [0,0,0,0,0,0,0,0]

func init():
	BasicAttack = get_parent().UnitStats.BasicAttack
	var parent:Unit_Instance = get_parent()
	if parent.Team == parent.Teams.PLAYER:
		if parent.is_team_leader:
			ability_usesB1234WAT = PlayerStats.p1_ability_usesB1234WAT
	else:
		ability_usesB1234WAT[0] = 999
		ability_usesB1234WAT[1] = Slot_1.max_uses
		ability_usesB1234WAT[2] = Slot_2.max_uses
		ability_usesB1234WAT[3] = Slot_3.max_uses
		ability_usesB1234WAT[4] = Slot_4.max_uses
		ability_usesB1234WAT[5] = WeaponAbility.max_uses
		ability_usesB1234WAT[6] = ArmourAbility.max_uses
		ability_usesB1234WAT[7] = TrinketAbility.max_uses
	pass
