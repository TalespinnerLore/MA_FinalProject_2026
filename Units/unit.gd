class_name Unit_Instance
extends CharacterBody2D

signal turn_start
signal move_complete
signal attack_start(ActionDef)
signal attack_end(ActionDef)
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
@export var is_active_unit:bool = false
@export var is_team_leader:bool = false
@export var in_combat = false

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
@export var Level:int = 1
@export var XP:int = 0
@export var XP_to_Level:int = 50
#var XP_to_Level_1to2 = 50

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
var Base_Phys_ATK = 5
var Base_Mag_ATK = 5
var Base_Phys_DEF = 5
var Base_Mag_DEF = 5
var Base_Evasion = 5
var Heal_Buff_Mult = 1.0
var Melee_Mult = 1.0
var Ranged_Mult = 1.0
var Def_Mult = 1.0
var Reroll_Chance = 0.05

func set_stats():
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


func calc_evasion_and_crit(accuracy,crit_boost:float): #runs on TARGETED UNIT
	var Hit_Chance = (accuracy - Base_Evasion)*0.05 #total attacking dex - defending dex
	var Crit_Chance = ((Hit_Chance-1.0)/5.0) + crit_boost
	
	#Miss_Chance = abs(Miss_Chance) #needs to be positive
	var hit_roll = randf_range(0.0,1.0)
	if hit_roll <= Hit_Chance:
		return [false, false] #[HIT, CRIT?]
	else:
		var crit_roll = randf_range(0.0,1.0)
		if crit_roll <= Crit_Chance:
			return [true, true] #[HIT, CRIT?]
		else:
			return [true, false] #[HIT, CRIT?]
	
	
			
	
		

func calc_damage(Damage_Type:int,amount:int,crit:bool,AttackingElement:ElementType): #runs on HIT UNIT
	var damage_taken = 0
	if crit == true:
		amount *= 2 #may change to 1.5, needs testing
	amount *= ElementalWeakness(AttackingElement,ElementalAffinity)
		
	if Damage_Type == 0 or Damage_Type == 1 or Damage_Type == 2: 
		#Phys Generic      #Phys Melee         #Phys Ranged
		damage_taken = amount-(Base_Phys_DEF*Def_Mult)
	elif Damage_Type == 3 or Damage_Type == 4 or Damage_Type == 5:
		#Magic Generic      #Magic Melee         #Magic Ranged
		damage_taken = amount-(Base_Mag_DEF*Def_Mult)
	else:
		damage_taken = amount*(1-Def_Mult)
		#totally generic damage, also here as an emergency stop so the game diesnt break in this scenario.
		
	if damage_taken < 1:
		damage_taken = 1 #all hits deal at least 1 damage, to ensure deadlocks can't happen in combat.
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
	var tilegrid: TileMapLayer
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
#BASIC MOVEMENT CODE
####################################################

func _physics_process(delta: float) -> void:
	if is_active_unit and Team == Teams.PLAYER and is_team_leader:
		if not moving:
			if get_dir_input() != Vector2.ZERO:
				move(get_dir_input())
			if Input.is_action_just_pressed("LeftClick"):
				pass #BASIC ATTACK HERE
				
			
	

func get_dir_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#match input_direction:
	#print(input_direction)
	return input_direction


var tile_size = 32
var animation_speed = 3
var moving  = false



var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN,\
Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN+Vector2.LEFT]



@onready var ray = $RayCast2D

func move(dir):
	ray.target_position = dir * tile_size #directions[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",\
			position + dir * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
		moving = true #^directions[dir]
		await tween.finished
		moving = false
		emit_signal("move_complete")

#######################################
#SPAWN CODE
#######################################


func init(is_player_controlled):
	print("unit ", self.name, " INITIALIZED")
	set_stats()
	
	if is_player_controlled:
		Team = Teams.PLAYER
	else: #FIX THIS LATER TO ACCOUNT FOR NPC AND ALLY UNITS
		Team = Teams.ENEMY
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func set_spawn(spawnpoint):
	position = grid_to_pos(spawnpoint,Vector2(0,0))[1] #the [1] gtes just the grid position

func _ready():
	pass


#######################################
#ABILITIES CODE
#######################################
var BasicAttack = ['Basic Attack', INF, 'MeleePhys', 'Front', 1, false, false, true]
var BasicAttacks = "Default Attack (Physical)"
var Slot1 = [] #[Name, MaxUses, DamageType, Targeting, Range, FriendlyFire, AllyOnly,Damaging]
var Slot2 = []
var Slot3 = []
var Slot4 = []
var GearSlot_Weapon = []
var GearSlot_Armour = []
var GearSlot_Trinket = []

#var Available_Abilities = [ActionDef]



func _on_turn_start() -> void:
	is_active_unit = true
	if Team == Teams.PLAYER or Team == Teams.ALLY:
		if is_team_leader:
			emit_signal("waiting_for_instructions",self_coords)
			pass #wait for instructions
		else:
			pass
