class_name AbilityData
extends Resource

enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum TargetType {Front, Line, Cone, Circle, Self}
enum Validity {Enemy, Ally, Any, Self}

@export var ability_name:String = 'Default Attack'
@export var sprite:Texture2D
@export var vfx:Texture2D
@export var element:ElementType = 4
@export var valid_target:Validity = 0 #Enemy, Ally, Any, Self
@export var targeting:TargetType = 0 #Front, Line, Cone, Circle, Specify
@export var range:int = 1
@export var base_value:int = 0
@export var damage_type:DamageType = 0
@export var damaging:bool = true
@export var healing:bool = false
@export var creates_shield:bool = false
@export var inflict_status:Array[StatusEffectData]
@export var sub_ability:AbilityData


@export_category("Requirements")
@export var STR_DEX_VIT_MAG_DEF_LUK = '<- reminder text variable'
@export var BaseStats_required = [0,0,0,0,0,0] #[STR,DEX,VIT,MAG,DEF,LUK]
@export var Abilities_required:Array[AbilityData]
