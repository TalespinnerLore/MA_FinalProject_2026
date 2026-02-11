class_name UnitAbility_DB
extends Resource

enum DamageType {Phys_Generic,Phys_Melee,Phys_Ranged,Mag_Generic,Mag_Melee,Mag_Ranged,Other}
enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum TargetType {Front, Line, Cone, Circle, Specify}
enum Validity {Enemy, Ally, Any, Self}
enum StatusEffect {None,Sleep,Burning,Taunting,Bleed}

var ability_name:String = 'Default Attack (Physical)'
var element:ElementType = 4
var valid_target:Validity = 0 #Enemy, Ally, Any, Self
var targeting:TargetType = 0 #Front, Line, Cone, Circle, Specify
var range:int = 1
var damage_type:DamageType = 0
var damaging:bool = true
var inflict_status:Array[StatusEffect]

var UnitAblities:Dictionary = {"Default Attack (Physical)":
								{"ability_name": 'Default Attack (Physical)',
								"element": ElementType.FORCE,
								"valid_target": Validity.Any,
								"targeting": TargetType.Front,
								"range": 1,
								"damage_type": DamageType.Phys_Generic,
								"damaging": true,
								"inflicts_status":[StatusEffect.None],
								"max_uses": INF},
								
							"Default Attack (Magic)":
								{"ability_name": 'Default Attack (Magic)',
								"element": ElementType.FORCE,
								"valid_target": Validity.Any,
								"targeting": TargetType.Front,
								"range": 1,
								"damage_type": DamageType.Mag_Generic,
								"damaging": true,
								"inflicts_status":[StatusEffect.None],
								"max_uses": INF},
								
							"Longshot": #default Ranger ability
								{"ability_name": 'Longshot',
								"element": 4,
								"valid_target": 0,
								"targeting": 0,
								"range": 100,
								"damage_type": 2,
								"damaging": true,
								"inflicts_status": 0},
								
							"Taunting Cry": #default Tank ability
								{"ability_name": 'Taunting Cry',
								"element": 4,
								"valid_target": 3,
								"targeting": 0,
								"range": 0,
								"damage_type": 6,
								"damaging": false,
								"inflicts_status": 3},
								
							"Cone of Force": #default Mage ability
								{"ability_name": 'Cone of Force',
								"element": 4,
								"valid_target": 0,
								"targeting": 2,
								"range": 2,
								"damage_type": 5,
								"damaging": true,
								"inflicts_status": 0},
								
							"Piercing Lunge": #default Warrior ability
								{"ability_name": 'Piercing Lunge',
								"element": 4,
								"valid_target": 0,
								"targeting": 1,
								"range": 2,
								"damage_type": 1,
								"damaging": true,
								"inflicts_status": 0},
								}
