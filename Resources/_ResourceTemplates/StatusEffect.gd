class_name StatusEffect
extends Resource

@export var effect_name = "[DEFAULT]"
@export var is_negative = false
@export var duration:int = 0 # number of turns it will last
@export var periodic:bool = false
enum trigger{EFFECT_GAINED,TURN_START,TURN_END,GETS_HIT,HITS_OTHER}
@export var periodic_trigger:trigger
@export var basedamage:int = 0 



@export var source = null #reference unit scene here at runtime?


func on_trigger():
	pass
