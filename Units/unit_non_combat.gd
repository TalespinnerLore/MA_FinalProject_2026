extends CharacterBody2D
class_name Unit_Instance_NonCombat

signal interact
signal move_complete
signal turn_complete

var facing:= Vector2i(1,0)
var last_tile:=Vector2i(-1,-1)
var last_door:=Vector2i(-1,-1)

@export var Team:Teams = 0
@export var TeamStrategy:Strategy = Strategy.FOLLOW
@export var self_coords = Vector2i(0,0)
@export var ElementalAffinity:ElementType = 4
@export var is_large_unit := false

enum Teams {PLAYER,ENEMY,ALLY,NPC}
enum Strategy {FOLLOW,AGGRESSIVE,}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}

@export_category("GEAR")

#@onready var ABILITIES:unit_equipped_abilities = $Abilities
@onready var EQUIPMENT:Unit_Equipment_Inventory = $Equipment
@onready var HP_Module = $Sprite2D/HP_module
#@onready var STATUS_EFECTS:StatusEffectManager = $StatusEffects

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
@export var XP_to_Level:int = 30
#var XP_to_Level_0to1 = 50

@export var XP_Mult = 1.0
@export var XP_to_Reward = 5
@export var BaseXP = 5

func Calc_XP_to_Level():
	XP_to_Level = 5*UnitLevel*((int(UnitLevel%5)+((5+int(UnitLevel/2.5)) * int(1+int(UnitLevel/5)+int(UnitLevel/10)))))
	print('xp to level calc: ',XP_to_Level)
	return 

func Calc_XP_to_Reward():
	XP_to_Reward = int(BaseXP*UnitLevel*XP_Mult)
	return XP_to_Reward

func give_XP(XP_togive,enem_level):
	print('getting xp now')
	print('xp_togive = ',XP_togive,' * (1 + 0.3 *[enemlvl-unitlevel: ',enem_level,'-',UnitLevel,'])')
	XP_togive = int(XP_togive * (1 + 0.3*clampi(enem_level-UnitLevel,-3,5)))
	XP+=XP_togive
	print('xp_togive = ',XP_togive)
	Attempt_LevelUp()

const Ability_vfx = preload("res://Objects/AbilityVFX.tscn")

func Attempt_LevelUp():
	print("ATTEMPT LEVEL-UP!")
	if XP >= XP_to_Level:
		UnitLevel+=1
		PlayerStats.p1_level = UnitLevel
		var vfx = Ability_vfx.instantiate()
		vfx.texture = load("res://Art/2D_images/lvl-up.png")
		vfx.life_span = 0.75
#		print(Ability.vfx.get_size())
		vfx.position = Global.grid_to_pos(self_coords)
		get_parent().get_parent().vfx_holder.add_child(vfx)
		
		print('level up to ',UnitLevel)
		if Team == Teams.PLAYER:
			match self.get_index():
				0: #team leader/only player char for now
					PlayerStats.p1_free_stats += UnitStats.Free_Stats
					print('player free stats, +',UnitStats.Free_Stats)
		set_stats()
		HP_Current = HP_Max
		#IncreaseStats(UnitStats.STR_up,UnitStats.DEX_up,UnitStats.VIT_up,UnitStats.MAG_up,UnitStats.DEF_up,UnitStats.LUK_up,UnitStats.Free_Stats)
		XP-=XP_to_Level
		Calc_XP_to_Level() #XP_to_Level = 
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
		#match self.get_index():
		#	0: #team leader/only player char for now
		UnitLevel = PlayerStats.p1_level
		investedstats = PlayerStats.p1_investedStrDexVitMagDefLuk
				#print("p1 base str: ",UnitStats.STR)
				#print("P1 invested stats: ",investedstats)
				#print("P1 LVL-UP stats: ",UnitStats.get_levelup_stats(UnitLevel))
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
	EQUIPMENT.on_spawn_apply_boosts()
	pass


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
	check_move_input()
	if Input.is_action_just_pressed("Interact"):
		print("attempt emit interact signal")
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
	#prev_path.append(self_coords)
	#$Sprite2D/pointer.look_at(self.global_position+(dir*Vector2(32,32)))
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
	

func _select_direction(dir:Vector2):
	facing = Vector2i(dir)
	return facing

########################

func _ready():
	if Team == Teams.PLAYER:
		if get_parent().get_child(0) == self:
			print("SDVERVEFVEDRFVER")
			#is_team_leader = true
			#print(PlayerStats.p1_class.resource_name)
		init(true)


func init(is_player_controlled):
	UnitStats = PlayerStats.p1_class
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
