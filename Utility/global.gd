extends Node

func has_variable(object:Object,var_name:String):
	return (var_name in object)

func get_variable_value(object:Object,var_name:String):
	return object.var_name

func randb():
	var b = randi_range(0,1)
	if b > 0:
		return true
	else:
		return false

@export var dir4 = [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]
@export var dir8 = [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT,\
					Vector2i.UP+Vector2i.LEFT,Vector2i.UP+Vector2i.RIGHT,\
					Vector2i.DOWN+Vector2i.LEFT,Vector2i.DOWN+Vector2i.RIGHT]

var tile_size = 32

func grid_to_pos(coord:Vector2i, pos:Vector2):
	coord = Vector2(coord)
	var to_grid = (pos-Vector2(tile_size/2,tile_size/2)) / tile_size
	var to_pos = Vector2(coord*tile_size) + Vector2(tile_size/2,tile_size/2)
	return([to_grid,to_pos]) #0 is grid coords, 1 is posistion according to Godot



var is_DraggingObject = false

enum RARITIES {BASIC,RARE,ELITE,UNIQUE}
enum ALIGNMENTS {NEUTRAL,GOOD,EVIL,CHAOTIC,LAWFUL}
enum ELEMENTS {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
enum MULT_ELEMENTS {STEAM,CRYSTAL,DUST,LIGHTNING,METAL,ICE,TWILIGHT}



#enum BIOMES {TEST,VOLCANO,ISLAND,MESA,SKY_ISLAND}
#enum ENV_FEATURES {RIVER,LAKE,FLOODED,BARREN}
#enum ROOMS {ROUND,DENSE,SPARSE,ALTERNATING_SIZE,SMALL,LARGE}

#enum SPAWN_RATE {MOBS,GOLD,ITEMS}
#enum ITEM_TYPE {GOLD,CONSUMABLE,GEAR,LOCKBOXES,KEY_ITEM}
#enum GEAR_TYPE {WEAPON,ARMOUR,TRINKET}
#enum CLASS {VANGUARD,WARRIOR,MAGE,ROGUE,HEALER,JESTER}
#enum MOB_TYPE {BEAST,ELEMENTAL,UNDEAD,CONSTRUCT,MORTAL,WILDLING}
#enum MOB_MODIFIERS {LEVEL,EXP,GOLD,GEAR}
#enum UNIQUE_ROOMS {TREASURE_ROOM,MONSTER_HOUSE}
#enum BOSS {T0_ROAMING,T0_MINI,T1_BOSS,T1_FIREBOSS,T1_WATERBOSS,T1_EARTHBOSS,T1_WINDBOSS,T1_FORCEBOSS,T2_BOSS,T2_QUADBOSS,T2_FORCEBOSS}

var DG_Mods:Dictionary = {"ELEMENTS":["FIRE","WATER","EARTH","AIR","FORCE","LIGHT","DARK"],
							"BIOMES":["TEST","VOLCANO","ISLAND","MESA","SKY_ISLAND"],
							"ENV_FEATURES":["RIVER","LAKE","FLOODED","BARREN"],
							"ROOMS":["ROUND_ROOMS","DENSE_LAYOUT","SPARSE_LAYOUT","ALTERNATING_SIZE_ROOMS","SMALL_ROOMS","LARGE_ROOMS"],
							"ITEM_TYPE":["GOLD","TILE","CONSUMABLE","GEAR","LOCKBOX","KEY_ITEM"],
							"ITEM_MODIFIERS":["SPAWN_RATE"],
							"GEAR_TYPE":["WEAPON","ARMOUR","TRINKET"],
							"CLASS":["VANGUARD","WARRIOR","MAGE","ROGUE","HEALER","JESTER"],
							"MOB_TYPE":["BEAST","ELEMENTAL","UNDEAD","CONSTRUCT","MORTAL","WILDLING"],
							"MOB_MODIFIERS":["SPAWN_RATE","LEVEL","EXP","GOLD","GEAR"],
							"UNIQUE_ROOMS":["TREASURE_ROOM","MONSTER_HOUSE"],
							"BOSS":["T0_ROAMING","T0_MINI","T1_BOSS","T1_FIREBOSS","T1_WATERBOSS","T1_EARTHBOSS","T1_WINDBOSS","T1_FORCEBOSS","T2_BOSS","T2_QUADBOSS","T2_FORCEBOSS"]
							}
		



#"BOSS":["T0_ROAMING","T0_MINI","T1_BOSS","T1_FIREBOSS","T1_WATERBOSS","T1_EARTHBOSS","T1_WINDBOSS","T1_FORCEBOSS","T2_BOSS","T2_QUADBOSS","T2_FORCEBOSS"]
