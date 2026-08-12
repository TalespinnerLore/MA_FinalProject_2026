extends Node
@export var StatusData:StatusEffectData
enum trigger{TURN_START,TURN_END,GETS_HIT,HITS_OTHER,EFFECT_LOST,EFFECT_GAINED}
enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}

const Ability_vfx = preload("res://Objects/AbilityVFX.tscn")
@onready var owning_unit:Unit_Instance = self.get_parent().get_parent() #will be in status effect container node
@export var source_unit:Unit_Instance
@onready var manager:StatusEffectManager = get_parent()

var stack_amount = 1

var turns_left:int = 0
var effect_name:String #StatusData.effect_name
var is_negative:bool #StatusData.is_negative
var base_damage:int #StatusData.base_damage
var damage_type:StatusEffectData.DamageType #StatusData.DamageType
var element:StatusEffectData.ElementType
var crit = false
var multiplier = 1.0

var affecting_value = 0.0

func _ready() -> void:
	turns_left = StatusData.turn_duration
	effect_name = StatusData.effect_name
	is_negative = StatusData.is_negative
	base_damage = StatusData.base_damage
	damage_type = StatusData.damage_type
	element = StatusData.element
	multiplier = source_unit.Heal_Buff_Mult
	
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
	
	owning_unit.turn_complete.connect(end_turn) #make end turn triggers happen on end_turn signal from attached unit.
	owning_unit.turn_start.connect(start_turn) #same as above, but fot turn start
	owning_unit.damaged.connect(on_get_hit)
	owning_unit.hit_other_unit.connect(on_hitting)
	on_gain()

#func change_stack(num:int):
#	stack_amount+=num
	

func apply_damage():
	var calcs = owning_unit.calc_damage(damage_type,int(base_damage*multiplier*stack_amount),crit,element)
	var pre = owning_unit.HP_Module.hp
	owning_unit.HP_Module._take_damage(calcs[0]) 
	var post = owning_unit.HP_Module.hp
	print("HP Before and After: ",pre," ",post," Turns remaining:",turns_left)

func apply_healing():
	owning_unit.calc_healing(int(base_damage*multiplier*stack_amount),crit,element)
	
func spawn_vfx():
	print("SPAWIN VFX = ",effect_name)
	var vfx = Ability_vfx.instantiate()
	vfx.texture = StatusData.vfx
	vfx.position = owning_unit.position
	if is_instance_valid(get_tree()):
		var vfx_container = get_tree().get_first_node_in_group("VFX_container") 
		vfx_container.add_child(vfx)

func periodic_effect():
	spawn_vfx()
	print("PERIODIC===EFFECT")
	match effect_name:
		'[DEFAULT]':
			print("How the hecka are you seeing this? Bug report this.")
			pass
		'Burning':
			apply_damage()
		'Poisoned':
			apply_damage()
			print("Poison perdiodic effect applied")
		'Regeneration':
			apply_healing()
		'Stunned': #50% chance / multiplier to skip a stunned unit's turn
			if randf_range(0.0,1.0) > 0.50/multiplier:
				owning_unit.skipping_turn = true
				print(owning_unit," is stunned and can't do anything.")
			else:
				print(owning_unit," snaps out of their stunned state!")
				on_timeout()

func on_gain():
	owning_unit.HP_Module.add_status_icon(StatusData)
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
				affecting_value = int(-5*multiplier)
				owning_unit.Mag_ATK_boost += affecting_value
				owning_unit.Phys_ATK_boost += affecting_value
				owning_unit.apply_calc_stat_boosts()
			'Haste':
				affecting_value = roundi(turns_left*multiplier)
				turns_left = affecting_value
				owning_unit.max_turn_actions = 2
	#######################################
	if StatusData.trigger_periodic_on_gain:
		periodic_effect()
	var index = -1
	for se in manager.get_children():
		index+=1
		print("index:",index," ",se.effect_name," can_stack: ",se.StatusData.can_stack)


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
			'Haste':
				owning_unit.max_turn_actions = 1
	#############################################################
	if StatusData.periodic_effect_trigger == trigger.EFFECT_LOST:
		periodic_effect()
	owning_unit.HP_Module.remove_status_icon(StatusData)
	
	owning_unit.turn_complete.disconnect(end_turn) #make end turn triggers happen on end_turn signal from attached unit.
	owning_unit.turn_start.disconnect(start_turn) #same as above, but fot turn start
	owning_unit.damaged.disconnect(on_get_hit)
	owning_unit.hit_other_unit.disconnect(on_hitting)
	
	manager.lose_effect_dialogue(StatusData)
	


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
	turns_left -= 1
	print("if this is zero, this should delete now: ",turns_left)
	if StatusData.has_periodic_effect and StatusData.periodic_effect_trigger == trigger.TURN_END:
		periodic_effect()
		
	if turns_left <= 0:
		on_timeout() #await 
		queue_free()
	

			
