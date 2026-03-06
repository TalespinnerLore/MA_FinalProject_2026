class_name StatusEffectData
extends Resource

@export var vfx:Texture2D
@export var effect_name = "[DEFAULT]"
@export var is_negative = false
@export var turn_duration:int = 1 # number of turns it will last

enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum trigger{TURN_START,TURN_END,GETS_HIT,HITS_OTHER,EFFECT_LOST,EFFECT_GAINED}
enum mult_stat{STR,DEX,VIT,MAG,DEF,LUK}

@export var has_periodic_effect:bool = false
@export var trigger_periodic_on_gain:bool = false
@export var trigger_effect_on_timeout:bool = false
@export var periodic_effect_trigger:trigger

@export var element:ElementType = 4
@export var damage_type:DamageType = 6
@export var base_damage:int = 0 
@export var can_stack:bool = false
@export var stat_multiplier:mult_stat
