extends Resource
class_name TypeList

enum TYPE{MORTAL,UNDEAD,ELEMENTAL,CONSTRUCT,BEAST,WILDLING}
@export var CreatureType:TYPE
@export var Common_Enemies:Array[StatComponent]
@export var Rare_Enemies:Array[StatComponent]
@export var MiniBoss_Enemies:Array[StatComponent]
