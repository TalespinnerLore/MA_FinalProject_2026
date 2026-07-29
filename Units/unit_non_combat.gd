extends CharacterBody2D
class_name Unit_Instance_NonCombat

signal interact
signal move_complete
signal turn_complete

const StatusEffect_instance = preload("res://Utility/Components/StatusEffectInstance.tscn")

####################################################
#CURRENT UNIT STATUS
####################################################
@export_category("UNIT STATUS")
@export var is_team_leader:bool = false
@export var is_active_unit:bool = false
var is_acting:bool = false

var facing:= Vector2i(1,0)
@export var Team:Teams = 0
@export var TeamStrategy:Strategy = Strategy.FOLLOW
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
	UnitStats.calc_template_stats()
	HP_Max = UnitStats.HP_Max_withVIT
	HP_Current = HP_Max
	STR = UnitStats.STR
	DEX = UnitStats.DEX
	VIT = UnitStats.VIT
	MAG = UnitStats.MAG
	DEF = UnitStats.DEF
	LUK = UnitStats.LUK
	HP_Max = UnitStats.HP_Max_withVIT
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

func calc_stats_with_boost():
	HP_Max = UnitStats.Base_HP + 5*(VIT+VIT_boost)
	Heal_Buff_Mult = 1.0 + 0.02*(VIT+VIT_boost)
	Base_Phys_ATK = STR + STR_boost
	Melee_Mult = 1.0 + 0.02*(STR + STR_boost)
	Base_Evasion = DEX+DEX_boost
	Ranged_Mult = 1.0 + 0.02*(DEX+DEX_boost)
	Base_Mag_ATK = MAG+MAG_boost
	Base_Phys_DEF = DEF+DEF_boost
	Base_Mag_DEF = (Base_Mag_ATK/2.0) + (Base_Phys_DEF/2.0)
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

var colliders = [$up,$down,$left,$right,$upleft,$upright,$downleft,$downright]
var dir = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,Vector2.UP+Vector2.LEFT,Vector2.UP+Vector2.RIGHT,Vector2.DOWN+Vector2.LEFT,Vector2.DOWN+Vector2.RIGHT]

func _physics_process(delta: float) -> void:
	if is_active_unit and Team == Teams.PLAYER and is_team_leader:
		is_acting = true
		check_move_input()
		if Input.is_action_just_pressed("LeftClick"):
			print("attempt emit signal")
			#get_tree().get_node
			emit_signal("interact")
			

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
	is_acting = false

	#end_turn()
	#_on_turn_start()
	pass

func _select_direction(dir:Vector2):
	facing = Vector2i(dir)
	return facing

########################

func _ready():
	if Team == Teams.PLAYER:
		if get_parent().get_child(0) == self:
			print("SDVERVEFVEDRFVER")
			is_team_leader = true
			#print(PlayerStats.p1_class.resource_name)
		init(true)


func init(is_player_controlled):
	set_stats()
	$Sprite2D/HP_module.hp = HP_Max
	$Sprite2D/HP_module.maxhp = HP_Max
	if is_player_controlled:
		Team = Teams.PLAYER
		$Sprite2D.texture = UnitStats.Sprite
	else: #FIX THIS LATER TO ACCOUNT FOR NPC AND ALLY UNITS
		Team = Teams.ENEMY
		$Sprite2D.texture = UnitStats.Sprite
	get_self_coords()

func set_spawn(spawnpoint):
	position = grid_to_pos(spawnpoint,Vector2(0,0))[1] #the [1] gtes just the grid position
