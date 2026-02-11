class_name UnitAbility_Data
extends Resource

enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum TargetType {Front, Line, Cone, Circle, Specify}
enum Validity {Enemy, Ally, Any}

var ability_name:String = 'Ability Name'
var valid_target:Validity = 0 #Enemy, Ally, Any
var targeting:TargetType = 0 #Front, Line, Cone, Circle, Specify
var range:int = 1
var damage_type:DamageType = 6
var damaging:bool = true
var inflict_status:Array[int]= [0]
