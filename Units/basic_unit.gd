extends Area2D
@export var Team = 'Enemy'
####################################################
#CHARACTER/UNIT STATISTICS
####################################################
#Experience
var Level = 1
var XP = 0
var XP_to_Level = 50

var XP_Mult = 1.1
var XP_to_Reward = 5
var BaseXP = 5

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

#Base Stats
var STR = 5.0
var DEX = 5.0
var VIT = 5.0
var MAG = 5.0
var DEF = 5.0
var LUK = 5.0

#Base Stats
var STR_boost = 0.0
var DEX_boost = 0.0
var VIT_boost = 0.0
var MAG_boost = 0.0
var DEF_boost = 0.0
var LUK_boost = 0.0

#CalculatedStats
var HP_Max = 50+50
var HP_Current = HP_Max
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


enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}

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
		amount *= 2
		
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
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN,\
Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN+Vector2.LEFT]

var animation_speed = 3
var moving  = false

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir,event)
	if event.is_action_pressed('ui_accept'):
		#AttackTiles(CoordList:Array, Damage_Type:int, Base_Damage:int, Friendly_Fire:bool, Ally_Only:bool, Damaging:bool):
		var target_coord = grid_to_pos(Vector2(0,0),ray.target_position)
		AttackTiles([target_coord[0]],0,Base_Phys_ATK*Melee_Mult, false,false,true)
		pass

@onready var ray = $RayCast2D

func move(dir,event):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",\
			position + inputs[dir] *    tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false
		if self.get_parent().FindNearbyFloorTiles(self_coords.x,self_coords.y) < 3:
			for i in inputs.keys():
				if Input.is_action_pressed(i):
					move(dir,event)
	#if Vector2(Vector2i(1,1) - Vector2i(1,0)) == Vector2.DOWN:
	#	print("matches")
	#else:
	#	print("nope")
	#	print(Vector2.DOWN)


#######################################
#SPAWN CODE
#######################################

func set_spawn(spawnpoint):
	position = grid_to_pos(spawnpoint,Vector2(0,0))[1]

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	calc_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
