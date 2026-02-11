class_name AbilityData
extends Resource

enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum TargetType {Front, Line, Cone, Circle, Specify}
enum Validity {Enemy, Ally, Any, Self}

@export var ability_name:String = 'Default Attack'
@export var element:ElementType = 4
@export var valid_target:Validity = 0 #Enemy, Ally, Any, Self
@export var targeting:TargetType = 0 #Front, Line, Cone, Circle, Specify
@export var range:int = 1
@export var damage_type:DamageType = 0
@export var damaging:bool = true
@export var inflict_status:Array[Resource]
@export var sub_ability:AbilityData

@export_category("Requirements")
@export var BaseStats_required = [0,0,0,0,0,0] #[STR,DEX,VIT,MAG,DEF,LUK]
@export var Abilities_required:Array[AbilityData]
