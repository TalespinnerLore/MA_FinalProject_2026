extends Node
@export var StatusData:StatusEffectData
enum trigger{TURN_START,TURN_END,GETS_HIT,HITS_OTHER,EFFECT_LOST,EFFECT_GAINED}
enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}

const Ability_vfx = preload("res://Objects/AbilityVFX.tscn")
@onready var owning_unit = self.get_parent().get_parent() #will be in status effect container node
var source_unit:Unit_Instance

var turns_left:int = 0
var effect_name = StatusData.effect_name
var is_negative = StatusData.is_negative
var base_damage = StatusData.base_damage
var damage_type = StatusData.DamageType
var element = StatusData.element
var crit = false
var multiplier = 1.0

var affecting_value = 0.0

func _ready() -> void:
	multiplier = source_unit.Heal_Buff_Multiplier
	match StatusData.stat_multiplier:
		StatusData.mult_stat.STR:
			multiplier += (source_unit.STR+source_unit.STR_boost)*0.01
		StatusData.mult_stat.DEX:
			multiplier += (source_unit.DEX+source_unit.DEX_boost)*0.01
		StatusData.mult_stat.VIT:
			multiplier += (source_unit.VIT+source_unit.VIT_boost)*0.01
		StatusData.mult_stat.MAG:
			multiplier += (source_unit.MAG+source_unit.MAG_boost)*0.01
		StatusData.mult_stat.MAG:
			multiplier += (source_unit.MAG+source_unit.MAG_boost)*0.01
		StatusData.mult_stat.LUK:
			multiplier += (source_unit.LUK+source_unit.LUK_boost)*0.01
	turns_left = StatusData.turn_duration
	effect_name = StatusData.effect_name
	owning_unit.turn_complete.connect(end_turn) #make end turn triggers happen on end_turn signal from attached unit.
	owning_unit.turn_start.connect(start_turn) #same as above, but fot turn start
	owning_unit.damaged.connect(on_get_hit)
	owning_unit.hit_other_unit.connect(on_hitting)
	on_gain()

func apply_damage():
	owning_unit.calc_damage(damage_type,base_damage,crit,element)

func apply_healing():
	owning_unit.calc_healing(base_damage,crit,element)
	
func spawn_vfx():
	var vfx = Ability_vfx.instantiate()
	vfx.texture = StatusData.vfx
	vfx.position = owning_unit.position
	$"../VFX".add_child(vfx)

func periodic_effect():
	spawn_vfx()
	match effect_name:
		'[DEFAULT]':
			print("How the hecka are you seeing this? Bug report this.")
			pass
		'Burning':
			apply_damage()
		'Poison':
			apply_damage()
		'Regeneration':
			apply_healing()
		'Stunned': #50% chance / multiplier to skip a stunned unit's turn
			if randf_range(0.0,1.0)/multiplier > 0.50:
				owning_unit.skipping_turn = true
				print(owning_unit," is stunned and can't do anything.")
			else:
				print(owning_unit," snaps out of their stunned state!")
				queue_free()

func on_gain():
	if is_negative:
		print(owning_unit," was ",effect_name,"!")
	else:
		print(owning_unit," gained ",effect_name,"!")
	#vvv THIS IS WHERE NON-PERIODIC EFFECTS HAPPEN, FOR THE MOST PART. vvv
	match effect_name:
			'[DEFAULT]':
				pass
			'Burning':
				pass
			'Poison':
				pass
			'Regeneration':
				pass
			'Stunned':
				pass
			'Precision': #10%*multiplier crit boost to affected unit
				affecting_value = 0.1*multiplier
				owning_unit.Crit_Boost += affecting_value
			'Gale Edge':#1 extra tile or range, times multiplier, rounded down to nearest integer.
				affecting_value = floori(1.0*multiplier)
				owning_unit.Range_Boost += affecting_value
				spawn_vfx()
			'Demoralized':
				affecting_value = -5*multiplier
				owning_unit.Mag_ATK_boost += affecting_value
				owning_unit.Phys_ATK_boost += affecting_value
				owning_unit.apply_calc_stat_boosts()
	#######################################
	if StatusData.trigger_periodic_on_gain:
		periodic_effect()

func on_timeout():
	match effect_name:
			'[DEFAULT]':
				pass
			'Burning':
				pass
			'Poison':
				pass
			'Regeneration':
				pass
			'Stunned':
				pass
			'Precision':
				owning_unit.Crit_Boost -= affecting_value
			'Gale Edge':
				owning_unit.Range_Boost -= affecting_value
			'Demoralized':
				owning_unit.Mag_ATK_boost -= affecting_value
				owning_unit.Phys_ATK_boost -= affecting_value
				owning_unit.apply_calc_stat_boosts()
	#############################################################
	if StatusData.periodic_effect_trigger == trigger.EFFECT_LOST:
		periodic_effect()


func on_get_hit():
	if StatusData.has_periodic_effect and StatusData.periodic_effect_trigger == trigger.GETS_HIT:
		periodic_effect()

func on_hitting():
	if StatusData.has_periodic_effect and StatusData.periodic_effect_trigger == trigger.HITS_OTHER:
		periodic_effect()

func start_turn():
	if StatusData.has_periodic_effect and StatusData.periodic_effect_trigger == trigger.TURN_START:
		periodic_effect()

func end_turn():
	if StatusData.has_periodic_effect and StatusData.periodic_effect_trigger == trigger.TURN_END:
		periodic_effect()
	
	turns_left -= 1
	if turns_left <= 0:
		on_timeout()
		queue_free()
	

			
