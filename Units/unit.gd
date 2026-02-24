class_name Unit_Instance
extends CharacterBody2D

signal turn_start
signal move_complete
signal attack_start(AbilityData)#attack_start(ActionDef)
#signal attack_end(ActionDef)
signal unit_defeated
signal unit_hit
signal damaged
signal turn_complete


####################################################
#CURRENT UNIT STATUS
####################################################
@export_category("UNIT STATUS")
@export var is_dead:bool = false
@export var has_taken_turn:bool = false
@export var is_team_leader:bool = false
@export var is_active_unit:bool = false
var is_acting:bool = false
@export var has_moved:bool = false
@export var in_combat = false
var facing:= Vector2i(1,0)
@export var Team:Teams = 0
@export var TeamStrategy:Strategy = 0
@export var self_coords = Vector2i(0,0)
@export var ElementalAffinity:ElementType = 4

enum Teams {PLAYER,ENEMY,ALLY,NPC}
enum Strategy {FOLLOW,AGGRESSIVE,}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}


####################################################
#CHARACTER/UNIT STATISTICS
####################################################
#Experience
@export_category('XP Stats')
@export var Level:int = 0
@export var XP:int = 0
@export var XP_to_Level:int = 50
#var XP_to_Level_0to1 = 50

@export var XP_Mult = 1.0
@export var XP_to_Reward = 5
@export var BaseXP = 5

func Calc_XP_to_Level():
	return(XP_to_Level*(1.0+(0.1*(Level-1))))

func Calc_XP_to_Reward():
	return (((BaseXP*(Level-1)/10) + BaseXP)*XP_Mult)

func Attempt_LevelUp():
	if XP >= XP_to_Level:
		Level+=1
		IncreaseStats(UnitStats.STR_up,UnitStats.DEX_up,UnitStats.VIT_up,UnitStats.MAG_up,UnitStats.DEF_up,UnitStats.LUK_up,UnitStats.Free_Stats)
		XP-=XP_to_Level
		XP_to_Level = Calc_XP_to_Level()
		if XP >= XP_to_Level:
			Attempt_LevelUp()

func IncreaseStats(str:int,dex:int,vit:int,mag:int,def:int,luk:int,free:int):
	STR+=str
	DEX+=dex
	VIT+=vit
	MAG+=mag
	DEF+=def
	LUK+=luk
	FREE_STATS = FREE_STATS-str-dex-vit-mag-def-luk+free
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
@export var HP_Max = 25
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
var Crit_Boost = 0.0

func set_stats():
	UnitStats.calc_stats()
	HP_Max = UnitStats.HP_Max
	HP_Current = HP_Max
	STR = UnitStats.STR
	DEX = UnitStats.DEX
	VIT = UnitStats.VIT
	MAG = UnitStats.MAG
	DEF = UnitStats.DEF
	LUK = UnitStats.LUK
	HP_Max = UnitStats.HP_Max
	Base_Phys_ATK = UnitStats.Base_Phys_ATK
	Base_Mag_ATK = UnitStats.Base_Mag_ATK
	Base_Phys_DEF = UnitStats.Base_Phys_DEF
	Base_Mag_DEF = UnitStats.Base_Mag_DEF
	Base_Evasion = UnitStats.Base_Evasion
	Heal_Buff_Mult = UnitStats.Heal_Buff_Mult
	Melee_Mult = UnitStats.Melee_Mult
	Ranged_Mult = UnitStats.Ranged_Mult
	Def_Mult = UnitStats.Def_Mult
	Reroll_Chance = UnitStats.Reroll_Chance

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
	print(Source," hits ",self.name)
	var hitcrit = calc_evasion_and_crit(Source.Base_Evasion,Source.Crit_Boost)
	if Ability.valid_target != 0:
		hitcrit = [true,hitcrit[1]]
	if hitcrit[0] == true:
		if Ability.damaging == true:
			match Ability.damage_type:
				0:
					amount = Source.Base_Phys_ATK
				1:
					amount = Source.Base_Phys_ATK * Source.Melee_Mult
					print(Source.Base_Phys_ATK, " * ",Source.Melee_Mult," = ",amount)
				2:
					amount = Source.Base_Phys_ATK * Source.Ranged_Mult
				3:
					amount = Source.Base_Mag_ATK
				4:
					amount = Source.Base_Mag_ATK * Source.Melee_Mult
				5:
					amount = Source.Base_Mag_ATK * Source.Ranged_Mult
				6:
					amount = 1
			print("Before: ",HP_Current)
			HP_Current -= calc_damage(Ability.damage_type,amount,hitcrit[1],Ability.element)
			$Sprite2D/HP_module._take_damage(calc_damage(Ability.damage_type,amount,hitcrit[1],Ability.element))
			print("After: ",HP_Current)
		if Ability.inflict_status.size() > 0:
			pass
	else:
		print("MISS!")
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
	if crit == true:
		print("CRITICAL HIT!")
		amount *= 2 #may change to 1.5, needs testing
	amount *= ElementalWeakness(AttackingElement,ElementalAffinity)
	print("Damamge with multipliers: ",amount)
		
	if Damage_Type == 0 or Damage_Type == 1 or Damage_Type == 2: 
		#Phys Generic      #Phys Melee         #Phys Ranged
		damage_taken = amount-(Base_Phys_DEF*Def_Mult)
		print("Damage negated by defense: ",roundi(Base_Phys_DEF*Def_Mult))
	elif Damage_Type == 3 or Damage_Type == 4 or Damage_Type == 5:
		#Magic Generic      #Magic Melee         #Magic Ranged
		damage_taken = amount-(Base_Mag_DEF*Def_Mult)
		print("Damage negated by defense: ",roundi(Base_Mag_DEF*Def_Mult))
	else:
		damage_taken = amount/Def_Mult
		print("Damage negated by defense: ",roundi(amount - amount/Def_Mult))
		#totally generic damage, also here as an emergency stop so the game doesn't break in this scenario.
	
	if damage_taken < 1:
		damage_taken = 1 #all hits deal at least 1 damage, to ensure deadlocks can't happen in combat.
	damage_taken = roundi(damage_taken)
	print("Damage after defence: ",damage_taken)
	return damage_taken



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
	self_coords = coords
	return(coords)

func grid_to_pos(coord, pos):
	var to_grid = (pos-Vector2(tile_size/2,tile_size/2)) / tile_size
	var to_pos = Vector2(coord*tile_size) + Vector2(tile_size/2,tile_size/2)
	return([to_grid,to_pos]) #0 is grid coords, 1 is posistion according to Godot


####################################################
#BASIC MOVEMENT/ACTION CODE
####################################################

func _physics_process(delta: float) -> void:
	if is_active_unit and Team == Teams.PLAYER and is_team_leader and ! has_moved:
		is_acting = true
		check_move_input()
		if Input.is_action_just_pressed("LeftClick"):
			print("attempt emit signal")
			#get_tree().get_node
			emit_signal("attack_start",$Abilities.BasicAttack,self)
			has_moved = true
			_on_turn_start()
			pass #BASIC ATTACK HERE ^^^
		
		elif Input.is_action_just_pressed("Ability_1"):
			emit_signal("attack_start",$Abilities.Slot_1,self)
		elif Input.is_action_just_pressed("Ability_2"):
			emit_signal("attack_start",$Abilities.Slot_2,self)
		elif Input.is_action_just_pressed("Ability_3"):
			emit_signal("attack_start",$Abilities.Slot_3,self)
		elif Input.is_action_just_pressed("Ability_4"):
			emit_signal("attack_start",$Abilities.Slot_4,self)
		#if not moving:
		#	if get_dir_input() != Vector2.ZERO:
		#		move(get_dir_input())
		#	
				
			

const tile_size = 32
var sprite_node_pos_tween: Tween
var move_duration:= 0.185

func check_move_input():
	#FOR SMOOTH MOVEMENT WITH HOLDING BUTTON, CHANGE is_action_just_pressed() FOR is_action_pressed().
	#NEED TO MAKE SURE THE REST OF THE TURN CYCLE GOES SMOOTHLY, AND ONLY WHEN NOT IN COMBAT STATE.
	if ! sprite_node_pos_tween or ! sprite_node_pos_tween.is_running():
		if Input.is_key_pressed(KEY_SHIFT):
			if Input.is_action_pressed("up") and Input.is_action_pressed("left"):
				_select_direction(Vector2.UP+Vector2.LEFT)
				if ! $upleft.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.UP+Vector2.LEFT)
			elif Input.is_action_pressed("up") and Input.is_action_pressed("right"):
				_select_direction(Vector2.UP+Vector2.RIGHT)
				if ! $upright.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.UP+Vector2.RIGHT)
			elif Input.is_action_pressed("down") and Input.is_action_pressed("left"):
				_select_direction(Vector2.DOWN+Vector2.LEFT)
				if ! $downleft.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.DOWN+Vector2.LEFT)
			elif Input.is_action_pressed("down") and Input.is_action_pressed("right"):
				_select_direction(Vector2.DOWN+Vector2.RIGHT)
				if ! $downright.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.DOWN+Vector2.RIGHT)
		else:
			if Input.is_action_just_pressed("up"):
				_select_direction(Vector2.UP)
				if ! $up.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.UP)
			elif Input.is_action_just_pressed("down"):
				_select_direction(Vector2.DOWN)
				if ! $down.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.DOWN)
			elif Input.is_action_just_pressed("left"):
				_select_direction(Vector2.LEFT)
				if ! $left.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.LEFT)
			elif Input.is_action_just_pressed("right"):
				_select_direction(Vector2.RIGHT)
				if ! $right.is_colliding() and ! Input.is_key_pressed(KEY_TAB):
					_move(Vector2.RIGHT)
			pass
	
	pass

func _move(dir:Vector2):
	global_position += dir*tile_size
	$Sprite2D.global_position -= dir * tile_size #lake the spirte lag behind by a tile
	facing = Vector2i(dir)
	if sprite_node_pos_tween: 
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, move_duration).set_trans(Tween.TRANS_SINE)
	#^^^actual movment is snappy, but visually the sprite moves smoothly - CAMERA TIED TO SPRITE, OR CHOPPY AS FUCK! My eyes...
	get_self_coords()
	has_moved = true
	is_acting = false
	emit_signal("turn_complete")
	_on_turn_start()
	pass

func _select_direction(dir:Vector2):
	facing = Vector2i(dir)
	return facing

#######################################
#SPAWN CODE
#######################################


func init(is_player_controlled):
	print(self," INITIALIZED")
	
	print("unit ", self.name, " INITIALIZED")
	set_stats()
	$Sprite2D/HP_module.hp = HP_Max
	$Sprite2D/HP_module.maxhp = HP_Max
	if is_player_controlled:
		Team = Teams.PLAYER
	else: #FIX THIS LATER TO ACCOUNT FOR NPC AND ALLY UNITS
		Team = Teams.ENEMY
		$Sprite2D.texture = UnitStats.Sprite
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	get_self_coords()
	print(self,"self_coords: ",self_coords)

func set_spawn(spawnpoint):
	position = grid_to_pos(spawnpoint,Vector2(0,0))[1] #the [1] gtes just the grid position




func _ready():
	pass

#######################################
#DEATH CODE
#######################################

func _on_death():
	if Team == Teams.ENEMY:
		#Award EXP
		#Roll Dropchance --- random pool
		#Roll Dropchance --- equipped gear
		pass
	else:
		pass
	#Play Death ANIMATION
	#
	queue_free()


#######################################
#ABILITIES CODE
#######################################



#var Available_Abilities = [ActionDef]



func _on_turn_start() -> void:
	is_active_unit = true
	has_moved = false
	if Team == Teams.PLAYER or Team == Teams.ALLY:
		if is_team_leader:
			emit_signal("waiting_for_instructions",self_coords)
			pass #wait for instructions
		else:
			pass

func reset_turn():
	print("reset turn - ",self.name)
	pass
