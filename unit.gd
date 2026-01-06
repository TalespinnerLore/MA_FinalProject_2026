class_name Unit_Instance
extends Node2D

signal move_complete
signal attack_start(ActionDef)
signal attack_end(ActionDef)
signal unit_defeated
signal damaged
signal turn_complete

var has_taken_turn = false

@export var Team = 'Enemy'
####################################################
#CHARACTER/UNIT STATISTICS
####################################################
#Experience
@export_category('XP Stats')
@export var Level:int = 1
@export var XP:int = 0
@export var XP_to_Level:int = 50

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
		XP-=XP_to_Level
		XP_to_Level = Calc_XP_to_Level()
		if XP >= XP_to_Level:
			Attempt_LevelUp()

@export_category('Base Stats')
#Base Stats
@export var STR:int = 5
@export var DEX:int = 5
@export var VIT:int = 5
@export var MAG:int = 5
@export var DEF:int = 5
@export var LUK:int = 5

@export_category('Base Stat Boosts')
#Base Stat Boosts
@export var STR_boost:int = 0
@export var DEX_boost:int = 0
@export var VIT_boost:int = 0
@export var MAG_boost:int = 0
@export var DEF_boost:int = 0
@export var LUK_boost:int = 0

@export_category('Calculated Stats')
#CalculatedStats
@export var HP_Max = 50+50
@export var HP_Current = HP_Max
var Base_Phys_ATK = 5.0
var Base_Mag_ATK = 5.0
var Base_Phys_DEF = 5.0
var Base_Mag_DEF = 5.0
var Base_Evasion = 5.0
var Heal_Buff_Mult = 1.1
var Melee_Mult = 1.1
var Ranged_Mult = 1.1
var Def_Mult = 1.1
var Reroll_Chance = 0.05

func calc_stats():
	HP_Max = 50 + 10*(VIT+VIT_boost)
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
#ATTACK CODE
####################################################

enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}

func calc_evasion_and_crit(accuracy):
	var Miss_Chance = (accuracy - DEX)*0.05
	var Crit_Chance = Miss_Chance/5.0
	if Crit_Chance > 0:
		var crit_roll = randf_range(0.0,1.0)
		if crit_roll <= Crit_Chance:
			return [true, true] #[HIT, CRIT?]
		else:
			return [true, false] #[HIT, CRIT?]
			
	else:
		Miss_Chance = abs(Miss_Chance) #needs to be positive
		var hit_roll = randf_range(0.0,1.0)
		if hit_roll <= Miss_Chance:
			return [false, false] #[HIT, CRIT?]
		else:
			return [true, false] #[HIT, CRIT?]

func calc_damage(Damage_Type:int,amount:int,crit:bool):
	var damage_taken = 0
	if crit == true:
		amount *= 2 #may change to 1.5, needs testing
		
	if Damage_Type == 0 or Damage_Type == 1 or Damage_Type == 2:
		damage_taken = amount-(Base_Phys_DEF*Def_Mult)
	elif Damage_Type == 3 or Damage_Type == 4 or Damage_Type == 5:
		damage_taken = amount-(Base_Mag_DEF*Def_Mult)
	else:
		damage_taken = amount*(1-Def_Mult)
		
	if damage_taken < 1:
		damage_taken = 1
	return damage_taken

func AttackTiles(CoordList:Array, Damage_Type:int, Base_Damage:int, Friendly_Fire:bool, Ally_Only:bool, Damaging:bool):
	var tilegrid: TileMapLayer
	for tile in CoordList:
		if (tilegrid.has_unit(tile) == true and tilegrid.get_team(tile) != Team and Friendly_Fire != true) \
		or (tilegrid.has_unit(tile) == true and tilegrid.get_team(tile) == Team and Ally_Only == true) \
		or (tilegrid.has_unit(tile) == true and Friendly_Fire == true): #IF there's a unit, calc damage unless it's friendly and friendly_fire is on.
			var unit = tilegrid.get_unit_data(tile) #[REFERENCE, NAME, TEAM]
			if Damaging == true:
				var hit_crit = unit[0].calc_evasion_and_crit(Base_Evasion) #[HIT, CRIT]
				if hit_crit[0] == true:
					unit.calc_damage(Damage_Type, Base_Damage, hit_crit[1])
	pass

####################################################
#LOCATION ON GRID CODE
####################################################

var self_coords = Vector2i(0,0)

func get_self_coords():
	var coords = (position-Vector2(tile_size/2,tile_size/2))/tile_size
	self_coords = coords
	return(coords)

func grid_to_pos(coord, pos):
	var to_grid = (pos-Vector2(tile_size/2,tile_size/2)) / tile_size
	var to_pos = Vector2(coord*tile_size) + Vector2(tile_size/2,tile_size/2)
	return([to_grid,to_pos]) #0 is grid coords, 1 is posistion according to Godot


####################################################
#BASIC MOVEMENT CODE
####################################################


var tile_size = 32
var animation_speed = 3
var moving  = false



var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN,\
Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN+Vector2.LEFT]



@onready var ray = $RayCast2D

func move(dir,event):
	ray.target_position = directions[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",\
			position + directions[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false

#######################################
#SPAWN CODE
#######################################

func set_spawn(spawnpoint):
	position = grid_to_pos(spawnpoint,Vector2(0,0))[1]

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	calc_stats()


#######################################
#ABILITIES CODE
#######################################
var BasicAttack = ['Basic Attack', INF, 'MeleePhys', 'Front', 1, false, false,true]
var Slot1 = [] #[Name, Uses, DamageType, Targeting, Range, FriendlyFire, AllyOnly,Damaging]
var Slot2 = []
var Slot3 = []
var Slot4 = []
