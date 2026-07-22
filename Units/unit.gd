class_name Unit_Instance
extends CharacterBody2D

signal turn_start
signal move_complete
signal attack_start(AbilityData)#attack_start(ActionDef)
#signal attack_end(ActionDef)
signal unit_defeated
signal hit_other_unit
signal damaged
signal turn_complete

const StatusEffect_instance = preload("res://Utility/Components/StatusEffectInstance.tscn")

####################################################
#CURRENT UNIT STATUS
####################################################
@export_category("UNIT STATUS")
@export var is_dead:bool = false
@export var has_taken_turn:bool = false
@export var is_team_leader:bool = false
@export var is_active_unit:bool = false
var is_acting:bool = false
var max_turn_actions = 1
var turn_actions_used = 0
@export var has_moved:bool = false
@export var in_combat:bool = false
@export var skipping_turn:bool = false
@export var has_shield:bool = false

var facing:= Vector2i(1,0)
var last_tile:=Vector2i(-1,-1)
var last_door:=Vector2i(-1,-1)

@export var Team:Teams = 0
@export var TeamStrategy:Strategy = Strategy.FOLLOW
@export var self_coords = Vector2i(0,0)
@export var ElementalAffinity:ElementType = 4

enum Teams {PLAYER,ENEMY,ALLY,NPC}
enum Strategy {FOLLOW,AGGRESSIVE,}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}

@export_category("GEAR")

@onready var ABILITIES:unit_equipped_abilities = $Abilities
@onready var EQUIPMENT:Unit_Equipment_Inventory = $Equipment

@export var ARMOUR:ItemData
@export var WEAPON:ItemData
@export var TRINKET:ItemData

@export var HeldItem:ItemData
@export var HeldItem_stacksize := 0

@export var held_gold := 0

@export var drop_held_weapon := false
@export var drop_held_armour := false
@export var drop_held_trinket := false

####################################################
#CHARACTER/UNIT STATISTICS
####################################################
#Experience
@export_category('XP Stats')
@export var UnitLevel:int = 1
@export var XP:int = 0
@export var XP_to_Level:int = 10
#var XP_to_Level_0to1 = 50

@export var XP_Mult = 1.0
@export var XP_to_Reward = 5
@export var BaseXP = 5

func Calc_XP_to_Level():
	return(XP_to_Level*(1.0+(0.1*(UnitLevel-1))))

func Calc_XP_to_Reward():
	XP_to_Reward = int((BaseXP*(UnitLevel-1/10) + BaseXP)*XP_Mult)
	return XP_to_Reward

func give_XP(XP_togive):
	print('getting xp now')
	XP+=XP_togive
	Attempt_LevelUp()

func Attempt_LevelUp():
	print("ATTEMPT LEVEL-UP!")
	if XP >= XP_to_Level:
		UnitLevel+=1
		if Team == Teams.PLAYER:
			match self.get_index():
				0: #team leader/only player char for now
					PlayerStats.p1_free_stats += UnitStats.Free_Stats
		set_stats()
		HP_Current = HP_Max
		#IncreaseStats(UnitStats.STR_up,UnitStats.DEX_up,UnitStats.VIT_up,UnitStats.MAG_up,UnitStats.DEF_up,UnitStats.LUK_up,UnitStats.Free_Stats)
		XP-=XP_to_Level
		XP_to_Level = Calc_XP_to_Level()
		if XP >= XP_to_Level:
			Attempt_LevelUp()
###vvv DEPRECIATED vvv###
func IncreaseStats(str:int,dex:int,vit:int,mag:int,def:int,luk:int,free:int):
	STR+=str
	DEX+=dex
	VIT+=vit
	MAG+=mag
	DEF+=def
	LUK+=luk
	FREE_STATS = FREE_STATS+free #-str-dex-vit-mag-def-luk
	pass

@export_category('UnitStats')
@export var UnitStats:StatComponent

@export_category('Base Stats')
#Base Stats
@export var STR:int = 0
@export var DEX:int = 0
@export var VIT:int = 0
@export var MAG:int = 0
@export var DEF:int = 0
@export var LUK:int = 0

@export var FREE_STATS:int = 0

@export_category('Calculated Stats')
#CalculatedStats
@export var HP_Max = 5
@export var HP_Current = HP_Max
@export var Base_Phys_ATK = 5
var Base_Mag_ATK = 5
var Base_Phys_DEF = 5
var Base_Mag_DEF = 5
var Base_Evasion = 5
var Heal_Buff_Mult = 1.0
var Melee_Mult = 1.0
var Ranged_Mult = 1.0
var Def_Mult = 1.0
var Reroll_Chance = 0.05
var Crit_Boost = 0.0 #APPLY AT CRIT CHANCE CALCULATION
var Range_Boost = 0 #extra tile range for abilities

@export_category('Stat Boosts') #Applied by gear, buffs, debuffs, etc.
#Base Stat Boosts
@export var STR_boost:int = 0
@export var DEX_boost:int = 0
@export var VIT_boost:int = 0
@export var MAG_boost:int = 0
@export var DEF_boost:int = 0
@export var LUK_boost:int = 0

#CalculatedStatBoosts
@export var HP_Max_boost = 0
@export var Phys_ATK_boost = 0
@export var Mag_ATK_boost = 0
@export var Phys_DEF_boost = 0
@export var Mag_DEF_boost = 0
@export var Evasion_boost = 0
@export var Heal_Buff_Mult_boost = 0.0
@export var Melee_Mult_boost = 0.0
@export var Ranged_Mult_boost = 0.0
@export var Def_Mult_boost = 0.0
@export var Reroll_Chance_boost = 0.00


func set_stats():
	print("0; hp:",HP_Current," max:",HP_Max)
	var investedstats = [0,0,0,0,0,0]
	if Team == Teams.PLAYER:
		match self.get_index():
			0: #team leader/only player char for now
				investedstats = PlayerStats.p1_investedStrDexVitMagDefLuk
				print("p1 base str: ",UnitStats.STR)
				print("P1 invested stats: ",investedstats)
				print("P1 LVL-UP stats: ",UnitStats.get_levelup_stats(UnitLevel))
	else:
		for i in UnitStats.Free_Stats*UnitLevel:
			investedstats[randi_range(0,5)] += 1
	var lvlUp_stats = UnitStats.get_levelup_stats(UnitLevel)
	UnitStats.calc_template_stats()
	print("p1 base str post clac: ",UnitStats.STR)
	#HP_Max = UnitStats.HP_Max_withVIT
	#HP_Current = HP_Max
	STR = lvlUp_stats[0] + investedstats[0]#UnitStats.STR + 
	DEX = lvlUp_stats[1] + investedstats[1]#UnitStats.DEX + 
	VIT = lvlUp_stats[2] + investedstats[2]#UnitStats.VIT + 
	MAG = lvlUp_stats[3] + investedstats[3]#UnitStats.MAG + 
	DEF = lvlUp_stats[4] + investedstats[4]#UnitStats.DEF + 
	LUK = lvlUp_stats[5] + investedstats[5]#UnitStats.LUK + 
	
	HP_Max_boost += UnitStats.HP_Max_boost
	Phys_ATK_boost += UnitStats.Phys_ATK_boost
	Mag_ATK_boost += UnitStats.Mag_ATK_boost
	Phys_DEF_boost += UnitStats.Phys_DEF_boost
	Mag_DEF_boost += UnitStats.Mag_DEF_boost 
	Evasion_boost += UnitStats.Evasion_boost 
	Heal_Buff_Mult_boost += UnitStats.Heal_Buff_Mult_boost 
	Melee_Mult_boost += UnitStats.Melee_Mult_boost
	Ranged_Mult_boost += UnitStats.Ranged_Mult_boost
	Def_Mult_boost += UnitStats.Def_Mult_boost
	Reroll_Chance_boost += UnitStats.Reroll_Chance_boost
	
	calc_stats_with_GearAndBuff_boost()
	print("1; hp:",HP_Current," max:",HP_Max)
	await get_tree().create_timer(0.15).timeout
	HP_Module.new_level_refresh(HP_Current,HP_Max)
	print("2; hp:",HP_Current," max:",HP_Max)

func calc_stats_with_GearAndBuff_boost():
	HP_Max = UnitStats.Base_HP + 2*(VIT+VIT_boost) + 2*UnitLevel
	Heal_Buff_Mult = 1.0 + 0.02*(VIT+VIT_boost)
	Base_Phys_ATK = STR + STR_boost
	Melee_Mult = 1.0 + 0.02*(STR + STR_boost)
	Base_Evasion = DEX+DEX_boost
	Ranged_Mult = 1.0 + 0.02*(DEX+DEX_boost)
	Base_Mag_ATK = MAG+MAG_boost
	Base_Phys_DEF = DEF+DEF_boost
	Base_Mag_DEF = (Base_Mag_ATK*0.75) + (Base_Phys_DEF*0.25)
	Def_Mult = 1.0 + 0.02*(DEF+DEF_boost)
	Reroll_Chance = 0.01*(LUK+LUK_boost)
	apply_calc_stat_boosts()
	pass

func apply_calc_stat_boosts():
	HP_Max += HP_Max_boost
	Base_Phys_ATK += Phys_ATK_boost
	Base_Mag_ATK += Mag_ATK_boost
	Base_Phys_DEF += Phys_DEF_boost
	Base_Mag_DEF += Mag_DEF_boost 
	Base_Evasion += Evasion_boost 
	Heal_Buff_Mult += Heal_Buff_Mult_boost 
	Melee_Mult += Melee_Mult_boost
	Ranged_Mult += Ranged_Mult_boost
	Def_Mult += Def_Mult_boost
	Reroll_Chance += Reroll_Chance_boost

####################################################
#LUCK CODE
####################################################

func reroll_outcome(attempts:int, go_lower:bool, prev_outcome:float, threshold:float):
	attempts-=1
	var new_outcome = randf_range(0.0,1.0)
	if go_lower == true and new_outcome <= threshold:
		return new_outcome
	elif go_lower == false and new_outcome >= threshold:
		return new_outcome
	elif attempts > 0:
		new_outcome = reroll_outcome(attempts, go_lower,prev_outcome,threshold)
	return new_outcome

####################################################
#ATTACK CODE
####################################################

func ability_effect_calculations(Ability:AbilityData,Source):
	var amount = 0
	var amount_negated = 0
	target_unit.combattext(str(Source," hits ",self.name))
	print(Source," hits ",self.name)
	var hitcrit = calc_evasion_and_crit(Source.Base_Evasion,Source.Crit_Boost)
	if (Ability.valid_target != 0 and Team != Teams.ENEMY and Ability.damaging == false) \
	or (Ability.valid_target == 0 and Team == Teams.ENEMY and Ability.damaging == false):
		hitcrit = [true,hitcrit[1]]
	if hitcrit[0] == true:
		match Ability.damage_type:
			0:
				amount = Source.Base_Phys_ATK
			1:
				amount = Source.Base_Phys_ATK * Source.Melee_Mult
				#print(Source.Base_Phys_ATK, " * ",Source.Melee_Mult," = ",amount)
			2:
				amount = Source.Base_Phys_ATK * Source.Ranged_Mult
				print(" base phys ",Source.Base_Phys_ATK," str ",Source.STR," str_b ",Source.STR_boost)
				print(" base phys ",Source.Ranged_Mult," str ",Source.DEX," str_b ",Source.DEX_boost)
				print(Source.Base_Phys_ATK, " * ",Source.Ranged_Mult," = ",amount)
			3:
				amount = Source.Base_Mag_ATK
			4:
				amount = Source.Base_Mag_ATK * Source.Melee_Mult
			5:
				amount = Source.Base_Mag_ATK * Source.Ranged_Mult
			6:
				amount = 1
		amount+=Ability.base_value
		print(amount-Ability.base_value, " + ",Ability.base_value," = ",amount)
		
		if Ability.damaging == true:
			target_unit.combattext(str("Before: ",HP_Current))
			print("Before: ",HP_Current)
			var calcs = calc_damage(Ability.damage_type,amount,hitcrit[1],Ability.element)
			amount = calcs[0]
			amount_negated = calcs[1]
			HP_Module._take_damage(amount)
			HP_Current = HP_Module.hp
			target_unit.combattext(str("After: ",HP_Current))
			print("After: ",HP_Current)
			in_combat = true
		if Ability.healing:
			var calcs = calc_healing(amount,hitcrit[1],Ability.element)
			amount = -1*calcs[0]
			amount_negated = calcs[1]
			HP_Module._take_damage(amount)
		
		if Ability.creates_shield: # and ! has_shield ##Shields overwrite other shields, probably plays better
			HP_Module.gain_shield(Ability,Source)
			print("MAKES SHIELD")
		
		if Ability.inflict_status.size() > 0:
			for s_effect in Ability.inflict_status:
				if ! $StatusEffects.has_stack(s_effect.effect_name):
					var s_instance = StatusEffect_instance.instantiate()
					s_instance.source_unit = Source
					s_instance.StatusData = s_effect
					$StatusEffects.add_child(s_instance)
				elif s_effect.can_stack:
					$StatusEffects.add_stack(s_effect.effect_name)
	else:
		target_unit.combattext(str("MISS!"))
		print("MISS!")
	#show_ability_use_result(source_unitname,hit_unitname,miss:bool,crit:bool,damage:int,damage_negated:int,effects_applied:Array[StatusEffectData])
	dialogue_manager_ref.show_ability_use_result(Source.UnitStats.UnitName,UnitStats.UnitName,hitcrit[0],hitcrit[1],amount,amount_negated,Ability.inflict_status)
	pass 

func calc_evasion_and_crit(Accuracy,crit_boost:float): #runs on TARGETED UNIT
	var Miss_Chance = 0.0
	var Crit_Chance = 0.0 + crit_boost
	if Base_Evasion > Accuracy:
		Miss_Chance += ((Base_Evasion-Accuracy)*0.01)
		Crit_Chance -= Miss_Chance
	elif Accuracy > Base_Evasion:
		Crit_Chance += ((Accuracy-Base_Evasion)*0.01)
	
	var hit_roll = randf_range(0.0,1.0)
	if hit_roll <= Miss_Chance:
		return [false, false] #[HIT, CRIT?]
	else:
		var crit_roll = randf_range(0.0,1.0)
		if crit_roll <= Crit_Chance:
			return [true, true] #[HIT, CRIT?]
		else:
			return [true, false] #[HIT, CRIT?]


func calc_damage(Damage_Type:int,amount:int,crit:bool,AttackingElement:int): #runs on HIT UNIT
	var damage_taken = 0
	var damage_negated = 0
	if crit == true:
		print("CRITICAL HIT!")
		amount *= 2 #may change to 1.5, needs testing
	amount *= ElementalWeakness(AttackingElement,ElementalAffinity)
	print("Damamge with multipliers: ",amount)
		
	if Damage_Type == 0 or Damage_Type == 1 or Damage_Type == 2: 
		#Phys Generic      #Phys Melee         #Phys Ranged
		damage_taken = amount-(Base_Phys_DEF*Def_Mult)
		damage_negated = roundi(Base_Phys_DEF*Def_Mult)
		print("Damage negated by defense: ",roundi(Base_Phys_DEF*Def_Mult))
	elif Damage_Type == 3 or Damage_Type == 4 or Damage_Type == 5:
		#Magic Generic      #Magic Melee         #Magic Ranged
		damage_taken = amount-(Base_Mag_DEF*Def_Mult)
		damage_negated = roundi(Base_Mag_DEF*Def_Mult)
		print("Damage negated by defense: ",roundi(Base_Mag_DEF*Def_Mult))
	else:
		damage_taken = amount/Def_Mult
		damage_negated = roundi(amount - amount/Def_Mult)
		print("Damage negated by defense: ",roundi(amount - amount/Def_Mult))
		#totally generic damage, also here as an emergency stop so the game doesn't break in this scenario.
	
	if damage_taken < 1:
		damage_taken = 1 #all hits deal at least 1 damage, to ensure deadlocks can't happen in combat.
	damage_taken = roundi(damage_taken)
	print("Damage after defence: ",damage_taken)
	return [damage_taken,damage_negated]

func calc_healing(amount:int,crit:bool,HealingElement:int):
	var healed = 0
	var negated = 0
	if crit == true:
		print("CRITICAL HEAL!")
		amount *= 2 #may change to 1.5, needs testing
	healed = amount * ElementalWeakness(HealingElement,ElementalAffinity)
	negated = abs(amount - healed)
	return [healed,negated]
	pass

func ElementalWeakness(AttackingElement:ElementType, DefendingElement:ElementType):
	match AttackingElement: #FIRE<WATER<EARTH<AIR<FIRE , DARK>LIGHT><FORCE><DARK<LIGHT
		0: #FIRE
			if DefendingElement == 1:
				return 0.5
			elif DefendingElement == 3:
				return 2.0
			else:
				return 1.0
		1: #WATER
			if DefendingElement == 2:
				return 0.5
			elif DefendingElement == 0:
				return 2.0
			else:
				return 1.0
		2: #EARTH
			if DefendingElement == 3:
				return 0.5
			elif DefendingElement == 1:
				return 2.0
			else:
				return 1.0
		3: #AIR
			if DefendingElement == 0:
				return 0.5
			elif DefendingElement == 2:
				return 2.0
			else:
				return 1.0
		4: #FORCE
			if DefendingElement == 5 or DefendingElement == 6:
				return 2.0
			else:
				return 1.0
		5: #LIGHT
			if DefendingElement == 4 or DefendingElement == 6:
				return 2.0
			else:
				return 1.0
		6: #DARK
			if DefendingElement == 5 or DefendingElement == 4:
				return 2.0
			else:
				return 1.0
	return 1.0 #if there is no elemental interaction, default to a 1x multiplier.

func AttackTiles(CoordList:Array, Damage_Type:int, AttackingElement:ElementType, Base_Damage:int, Friendly_Fire:bool, Ally_Only:bool, Damaging:bool):
	var tilegrid:TileMapLayer
	for tile in CoordList:
		if (tilegrid.has_unit(tile) == true and tilegrid.get_team(tile) != Team and Friendly_Fire != true) \
		or (tilegrid.has_unit(tile) == true and tilegrid.get_team(tile) == Team and Ally_Only == true) \
		or (tilegrid.has_unit(tile) == true and Friendly_Fire == true): #IF there's a unit, calc damage unless it's friendly and friendly_fire is on.
			var unit = tilegrid.get_unit_data(tile) #[REFERENCE, NAME, TEAM]
			if Damaging == true:
				var hit_crit = unit[0].calc_evasion_and_crit(Base_Evasion) #[HIT, CRIT]
				if hit_crit[0] == true:
					unit.calc_damage(Damage_Type, Base_Damage, hit_crit[1],AttackingElement)
	pass

####################################################
#LOCATION ON GRID CODE
####################################################



func get_self_coords():
	var coords = (position-Vector2(tile_size/2,tile_size/2))/tile_size
	self_coords = Vector2i(coords)
	return(coords)

func grid_to_pos(coord, pos):
	var to_grid = (pos-Vector2(tile_size/2,tile_size/2)) / tile_size
	var to_pos = Vector2(coord*tile_size) + Vector2(tile_size/2,tile_size/2)
	return([to_grid,to_pos]) #0 is grid coords, 1 is posistion according to Godot


####################################################
#BASIC MOVEMENT/ACTION CODE
####################################################

func _physics_process(delta: float) -> void:
	if is_active_unit and Team == Teams.PLAYER and is_team_leader and ! has_moved and ! has_taken_turn:
		is_acting = true
		
		if ! waiting_for_dialogue:
			
			check_move_input()
			
			if Input.is_action_just_pressed("LeftClick") and ! Input.is_key_pressed(KEY_Q):
				use_ability(0)
				#print("attempt emit signal")
				#get_tree().get_node
				#connect_dialogue()
				#emit_signal("attack_start",$Abilities.BasicAttack,self)
				#combattext(str(self.name," uses ",$Abilities.BasicAttack.ability_name,"!"))
				#action_used()
				#has_moved = true
				#_on_turn_start()
				pass #BASIC ATTACK HERE ^^^
			
			elif Input.is_action_just_pressed("Ability_1"):
				use_ability(1)
			elif Input.is_action_just_pressed("Ability_2"):
				use_ability(2)
			elif Input.is_action_just_pressed("Ability_3"):
				use_ability(3)
			elif Input.is_action_just_pressed("Ability_4"):
				use_ability(4)
		#if not moving:
		#	if get_dir_input() != Vector2.ZERO:
		#		move(get_dir_input())
		#	

func use_ability(index):
	if Abilities.ability_usesB1234WAT[index] > 0:
		if Abilities.ability_usesB1234WAT[index] < 100:
			Abilities.ability_usesB1234WAT[index] -= 1
		connect_dialogue()
		match index:
			0:
				emit_signal("attack_start",$Abilities.BasicAttack,self)
				combattext(str(self.name," uses ",$Abilities.BasicAttack.ability_name,"!"))
			1:
				emit_signal("attack_start",$Abilities.Slot_1,self)
				combattext(str(self.name," uses ",$Abilities.Slot_1.ability_name,"!"))
			2:
				emit_signal("attack_start",$Abilities.Slot_2,self)
				combattext(str(self.name," uses ",$Abilities.Slot_2.ability_name,"!"))
			3:
				emit_signal("attack_start",$Abilities.Slot_3,self)
				combattext(str(self.name," uses ",$Abilities.Slot_3.ability_name,"!"))
			4:
				emit_signal("attack_start",$Abilities.Slot_4,self)
				combattext(str(self.name," uses ",$Abilities.Slot_4.ability_name,"!"))
			5:
				emit_signal("attack_start",$Abilities.WeaponAbility,self)
				combattext(str(self.name," uses ",$Abilities.WeaponAbility.ability_name,"!"))
			6:
				emit_signal("attack_start",$Abilities.ArmourAbility,self)
				combattext(str(self.name," uses ",$Abilities.ArmourAbility.ability_name,"!"))
			7:
				emit_signal("attack_start",$Abilities.TrinketAbility,self)
				combattext(str(self.name," uses ",$Abilities.TrinketAbility.ability_name,"!"))
		action_used()
	else:
		push_error("Ability Out of Uses!")
		pass

func combattext(string):
	$CombatText.text = str(string +"\n")

const move_durations_onsc_offsc = [0.185,0.005]
const tile_size = 32
var sprite_node_pos_tween: Tween
var move_duration:= 0.185
var movable_directions = [0,0,0,0,0,0,0,0]

func check_8dir_collision():
	movable_directions[0] = $up.is_colliding()
	movable_directions[1] = $upright.is_colliding()
	movable_directions[2] = $right.is_colliding()
	movable_directions[3] = $downright.is_colliding()
	movable_directions[4] = $down.is_colliding()
	movable_directions[5] = $downleft.is_colliding()
	movable_directions[6] = $left.is_colliding()
	movable_directions[7] = $upleft.is_colliding()
	#var u = $up.is_colliding()
	#var ur = $upright.is_colliding()
	#var r = $right.is_colliding()
	#var dr = $downright.is_colliding()
	#var d = $down.is_colliding()
	#var dl = $downleft.is_colliding()
	#var l = $left.is_colliding()
	#var ul = $upleft.is_colliding()
	#return [u,ur,r,dr,d,dl,l,ul]

func check_relative_collision():
	var valid_dirs = []
	var dirs = [Vector2i.UP, Vector2i.UP+Vector2i.RIGHT, Vector2i.RIGHT, Vector2i.DOWN+Vector2i.RIGHT,\
				Vector2i.DOWN,Vector2i.DOWN+Vector2i.LEFT,Vector2i.LEFT,Vector2i.UP+Vector2i.LEFT]
	check_8dir_collision()
	#print(movable_directions)
	var i = 0
	for dir in dirs:
		if movable_directions[i] != true: #if not colliding
			valid_dirs.append(dir)
		else:
			pass
			#valid_dirs.append(Vector2i(0,-3))
		i+=1
	return valid_dirs

func check_move_input():
	#FOR SMOOTH MOVEMENT WITH HOLDING BUTTON, CHANGE is_action_just_pressed() FOR is_action_pressed().
	#NEED TO MAKE SURE THE REST OF THE TURN CYCLE GOES SMOOTHLY, AND ONLY WHEN NOT IN COMBAT STATE.
	
	if ! sprite_node_pos_tween or ! sprite_node_pos_tween.is_running():
		if Input.is_key_pressed(KEY_SHIFT):
			if Input.is_action_pressed("up") and Input.is_action_pressed("left"):
				_select_direction(Vector2.UP+Vector2.LEFT)
				if ! $upleft.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.UP+Vector2.LEFT)
			elif Input.is_action_pressed("up") and Input.is_action_pressed("right"):
				_select_direction(Vector2.UP+Vector2.RIGHT)
				if ! $upright.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.UP+Vector2.RIGHT)
			elif Input.is_action_pressed("down") and Input.is_action_pressed("left"):
				_select_direction(Vector2.DOWN+Vector2.LEFT)
				if ! $downleft.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.DOWN+Vector2.LEFT)
			elif Input.is_action_pressed("down") and Input.is_action_pressed("right"):
				_select_direction(Vector2.DOWN+Vector2.RIGHT)
				if ! $downright.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.DOWN+Vector2.RIGHT)
		else:
			if Input.is_action_pressed("up"):
				_select_direction(Vector2.UP)
				if ! $up.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.UP)
			elif Input.is_action_pressed("down"):
				_select_direction(Vector2.DOWN)
				if ! $down.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.DOWN)
			elif Input.is_action_pressed("left"):
				_select_direction(Vector2.LEFT)
				if ! $left.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.LEFT)
			elif Input.is_action_pressed("right"):
				_select_direction(Vector2.RIGHT)
				if ! $right.is_colliding() and ! Input.is_key_pressed(KEY_TAB) and ! Input.is_key_pressed(KEY_CTRL):
					_move(Vector2.RIGHT)
			pass
	
	pass

func _move(dir:Vector2):
	$Sprite2D/pointer.look_at(self.global_position+(dir*Vector2(32,32)))
	last_tile = self_coords
	global_position += dir*tile_size
	get_self_coords()
	$Sprite2D.global_position -= dir * tile_size #lake the spirte lag behind by a tile
	facing = Vector2i(dir)
	if sprite_node_pos_tween: 
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	await sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, move_duration).set_trans(Tween.TRANS_SINE)
	#^^^actual movment is snappy, but visually the sprite moves smoothly - CAMERA TIED TO SPRITE, OR CHOPPY AS FUCK! My eyes...
	
	has_moved = true
	is_acting = false
	action_used()
	#end_turn()
	#_on_turn_start()
	pass

func _select_direction(dir:Vector2):
	facing = Vector2i(dir)
	set_pointer_at_facing()
	return facing

func action_used():
	if waiting_for_dialogue:
		#print("WAIT BEGINS")
		#print("signal 'wainint on dialogue' emitting now")
		emit_signal("waiting_on_dialogue")
		
		await dialogue_manager_ref.action_complete
		#print("WAIT COMPLETE")
		waiting_for_dialogue = false
	
	if is_team_leader and Team == Teams.PLAYER:
		pass
		#await get_tree().create_timer(1.0).timeout
	else:
		pass
		#await get_tree().create_timer(0.1).timeout
	turn_actions_used+=1
	if turn_actions_used>=max_turn_actions:	
		end_turn()
#######################################
#SPAWN CODE
#######################################


func init(is_player_controlled):
	#print(self," INITIALIZED")
	HP_Module = $Sprite2D/HP_module
	#print("unit ", self.name, " INITIALIZED")
	
	if is_player_controlled:
		Team = Teams.PLAYER
		
		UnitStats = PlayerStats.p1_class
		$Abilities.Slot_1 = PlayerStats.p1_equipped_abilities[0]
		$Abilities.Slot_2 = PlayerStats.p1_equipped_abilities[1]
		$Abilities.Slot_3 = PlayerStats.p1_equipped_abilities[2] #testing
		$Abilities.Slot_4 = PlayerStats.p1_equipped_abilities[3] #testing
#		$Sprite2D/Button1.visible = true
#		$Sprite2D/Button2.visible = true
#		$Sprite2D/Button1.icon = $Abilities.Slot_1.vfx
#		$Sprite2D/Button1.text = str("1: ",$Abilities.Slot_1.ability_name)
#		$Sprite2D/Button2.icon = $Abilities.Slot_2.vfx
#		$Sprite2D/Button2.text = str("2: ",$Abilities.Slot_2.ability_name)
		set_stats()
		#print("initial set stats on init; hp:",HP_Current," max:",HP_Max)
		$Sprite2D.texture = UnitStats.Sprite
		$Abilities.init()
		print("floornum ", DungeonData.current_floor)
		if DungeonData.current_floor > 1:
			#print("should not trigger; hp:",HP_Current," max:",HP_Max)
			HP_Current = PlayerStats.p1_HP
			HP_Module.hp = HP_Current
			HP_Module.maxhp = HP_Max
			print("currentHP: ",HP_Current," maxHP",HP_Max)
			await get_tree().create_timer(0.15).timeout
			HP_Module.new_level_refresh(HP_Current,HP_Max)
		else:
			HP_Current = HP_Max
			HP_Module.new_level_refresh(HP_Current,HP_Max)
		XP = PlayerStats.p1_XP
		UnitLevel = PlayerStats.p1_level
		for i in UnitLevel:
			Calc_XP_to_Level()
	else: #FIX THIS LATER TO ACCOUNT FOR NPC AND ALLY UNITS
		$Label.visible = false
		Team = Teams.ENEMY
		set_stats()
		HP_Current = HP_Max
		HP_Module.new_level_refresh(HP_Current,HP_Max)
		$Abilities.init()
		$Sprite2D.texture = UnitStats.Sprite
		Calc_XP_to_Reward()
	target_unit = get_tree().get_first_node_in_group("Player")
	dialogue_manager_ref = get_tree().get_first_node_in_group("DIALOGUE_MANAGER")
	

	#position = position.snapped(Vector2.ONE * tile_size)
	#position += Vector2.ONE * tile_size/2
	get_self_coords()
	#print(self,"self_coords: ",self_coords)

func set_spawn(spawnpoint:Vector2i):
	print("spawned in at:",self_coords, " ",self.global_position)
	print("going to spawnpoint: ",spawnpoint, " ",Global.grid_to_pos(spawnpoint))
	self.global_position = Global.grid_to_pos(spawnpoint)
	#position = grid_to_pos(spawnpoint,Vector2(0,0))[1] #the [1] gtes just the grid position
	get_self_coords()
	print("unitinstance setspawn; spawnpoint:",self_coords," locaction:",self.position," gp:",self.global_position)

@onready var HP_Module = $Sprite2D/HP_module

@onready var Abilities = $Abilities

func _ready():
	if ! $VisibleOnScreenNotifier2D.is_on_screen():
		_on_visible_on_screen_notifier_2d_screen_exited()
	#print("-1; hp:",HP_Current," max:",HP_Max)
	#
	#await get_tree().create_timer(5).timeout
	#self.global_position = Vector2(368, 688)
	pass

#######################################
#DEATH CODE
#######################################
signal player_died

var goldscene = preload("res://Objects/Items/GroundItem.tscn")

func _on_death():
	#emit_signal("unit_defeated")
	get_parent()._on_unit_defeated(XP_to_Reward)
	if Team == Teams.ENEMY:
		if UnitStats.UnitName != "MiniBoss":
			var gold = goldscene.instantiate()
			gold.global_position = self.global_position
			$"../../../GroundItem_Manager".add_child(gold)
			$"../../../GroundItem_Manager".get_child(-1)._init()
			emit_signal("unit_defeated",XP_to_Reward)
			queue_free()
		else:
			await get_tree().create_timer(2).timeout
			self.process_mode = Node.PROCESS_MODE_ALWAYS
			var unit_manager_ref = get_tree().get_first_node_in_group("UNIT_MANAGER")
			unit_manager_ref.player_dead = true
			unit_manager_ref.get_child(1).player_dead = true
			await $"../../../CanvasLayer/DialogueSystemBase".action_complete
			get_tree().paused = true
			get_tree().change_scene_to_file("res://Scenes/StaticLevels/HubScene_Playtesting.tscn")
		#Award EXP
		#Roll Dropchance --- random pool
		#Roll Dropchance --- equipped gear
		pass
	else:
		#emit_signal("player_died")
		self.process_mode = Node.PROCESS_MODE_ALWAYS
		var unit_manager_ref = get_tree().get_first_node_in_group("UNIT_MANAGER")
		unit_manager_ref.player_dead = true
		unit_manager_ref.get_child(1).player_dead = true
		await $"../../../CanvasLayer/DialogueSystemBase".action_complete
		get_tree().paused = true
		get_tree().change_scene_to_file("res://Scenes/StaticLevels/HubScene_Playtesting.tscn")
		#await get_tree().create_timer(2).timeout
		pass
	#Play Death ANIMATION
	
	#queue_free()


#######################################
#ABILITIES CODE
#######################################



#var Available_Abilities = [ActionDef]



func _on_turn_start() -> void:
	is_active_unit = true
	turn_actions_used = 0
	has_moved = false
	skipping_turn = false
	emit_signal("turn_start")
	
	if skipping_turn:
		print("hit Skip TURN")
		skipping_turn = false
		end_turn()
	
	if Team == Teams.PLAYER or Team == Teams.ALLY:
		if is_team_leader:
			#emit_signal("waiting_for_instructions",self_coords)
			
			pass #wait for instructions
		else:
			print("player team AI turn not yet implemented")
			pass
	else:
		await get_tree().create_timer(0.05).timeout
		AI_turn_enemy()
	

var goal_tile:Vector2i
var target_unit:Unit_Instance
#@onready var pathfinding_manager:PathfindingManager = $"../../../PathfindingManager" #temp fix for now
var path:Array[Vector2i] = []

func AI_turn_enemy():
	#print("################# enemy AI turn start ####################")
	if in_combat:
		#print("enemy AI is in combat")
		#target_unit = get_tree().get_first_node_in_group("Player")
		#print("self: ",self_coords," player: ",target_unit.self_coords)
		facing = Vector2i(clampi(self_coords.x - target_unit.self_coords.x,-1,1),clampi(self_coords.y - target_unit.self_coords.y,-1,1))
		facing *= -1
		goal_tile = target_unit.self_coords
		var non_coll = check_relative_collision()
		if abs(goal_tile-self_coords).length() > 1.5: #if not next to target ##check if straight line AND max range of all attacks
			#goal_tile = pathfinding_manager.get_valid_path(self_coords,target_unit.self_coords)[0]
			if non_coll.has(facing):
				#print([Vector2i.UP, Vector2i.UP+Vector2i.RIGHT, Vector2i.RIGHT, Vector2i.DOWN+Vector2i.RIGHT,\
				#	Vector2i.DOWN,Vector2i.DOWN+Vector2i.LEFT,Vector2i.LEFT,Vector2i.UP+Vector2i.LEFT])
				#print(Global.dir8)
				#print("non-coll: ",non_coll, " facing: ",facing)
				#print("has facing")
				print("enemAI; onscreen-",$VisibleOnScreenNotifier2D.is_on_screen()," moverate-",move_duration)
				_move(facing)
			elif non_coll.size() <= 0:
				print("AI unit is surrounded, can't move")
				pass
			else:
				var new_dir = non_coll.pick_random()
				facing = new_dir
				set_pointer_at_facing()
						

				print("enemAI; onscreen-",$VisibleOnScreenNotifier2D.is_on_screen()," moverate-",move_duration)
				_move(facing)
			action_used()
			pass
		else:
			set_pointer_at_facing()
			#choose_ability() ##score abilities for viability, choose 1, use it.
			#print("AI attacks")
			connect_dialogue()
			use_ability(0)
		pass
	else:
		#if path.size() < 1:
		#	path = pathfinding_manager.get_valid_path(self_coords,$"../../../TileMapLayer".cells_Ground.pick_random())
		#	print(self,path)
		#^^^ unfuck this atrocious line of code over the weekend
		#goal_tile = path[0]
		#print("selftile: ",self_coords,"  next tile: ",goal_tile)
		#facing = Vector2i(goal_tile) - Vector2i(self_coords)
		#_move(facing)
		#print("newtile: ",self_coords)
		#path.pop_front()
		path_random_tile()
		action_used()
		pass
	pass

func set_pointer_at_facing():
	print("facing:",facing," length:",facing.length())
	if facing.length() < 1.4:
		$Sprite2D/pointer.visible = true
		$Sprite2D/pointer_diag.visible = false
		$Sprite2D/pointer.look_at(self.global_position+(Vector2(facing)*Vector2(32,32)))
	else:
		$Sprite2D/pointer.visible = false
		$Sprite2D/pointer_diag.visible = true
		match facing:
			Vector2i(1,-1):
				$Sprite2D/pointer_diag.set_rotation_degrees(0)
			Vector2i(-1,1):
				$Sprite2D/pointer_diag.set_rotation_degrees(180)
			Vector2i(1,1):
				$Sprite2D/pointer_diag.set_rotation_degrees(90)
			Vector2i(-1,-1):
				$Sprite2D/pointer_diag.set_rotation_degrees(270)

func path_random_tile():
	var rand_dir = Global.dir8
	rand_dir.shuffle()
	var valid = $"../../../TileMapLayer".cells_Ground
	for dir in rand_dir:
		var target_tile:Vector2i = Vector2i(self_coords)+Vector2i(dir)
		if valid.has(target_tile):
			facing = target_tile - Vector2i(self_coords)
			break
	set_pointer_at_facing()
	_move(facing)


func AI_turn_ally():
	pass

func AI_turn_npc():
	pass

func check_in_range():
	pass 


func reset_turn():
	has_taken_turn = false
	pass

func end_turn():
	has_taken_turn = true
	#cleartext()
	if Team == Teams.PLAYER:
		print("PLAYER END TURN SVBNEROMERPVOM")
	emit_signal("turn_complete")

func cleartext():
	$CombatText.text = ""

@export var dialogue_manager_ref:DialogueManager
var waiting_for_dialogue: = false
signal waiting_on_dialogue

func connect_dialogue():
	print("connecting to dialogue")
	waiting_for_dialogue = true
	if self != null:
		dialogue_manager_ref.connect_to_unit(self)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	move_duration = move_durations_onsc_offsc[0]


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	move_duration = move_durations_onsc_offsc[1]
