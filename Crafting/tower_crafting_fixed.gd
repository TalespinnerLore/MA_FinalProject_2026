extends Node2D

enum gridTier {T0,T1,T2,T2_5,T3}
enum R {BASIC,RARE,ELITE,UNIQUE}

const middle_coord = Vector2(320,180)

var t0_cross_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1)]
var t0_cross_rarities = [R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.RARE]

var t1_grid3_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1),\
						Vector2(-1,-1),Vector2(1,1),Vector2(1,-1),Vector2(-1,1)]
var t1_grid3_rarities = [R.RARE,R.RARE,R.RARE,R.RARE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.ELITE]

var t2_edge8_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1),\
						Vector2(-1,-1),Vector2(1,1),Vector2(1,-1),Vector2(-1,1),\
						Vector2(-2,0),Vector2(2,0),Vector2(0,-2),Vector2(0,2),\
						Vector2(-2,-2),Vector2(2,2),Vector2(2,-2),Vector2(-2,2)]
var t2_edge8_rarities = [R.RARE,R.RARE,R.RARE,R.RARE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,\
						R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.ELITE,R.ELITE,R.ELITE,R.ELITE,R.UNIQUE]

var t2_5_rarities = [[R.ELITE,R.ELITE,R.ELITE,R.ELITE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,\
						R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.UNIQUE,R.UNIQUE,R.UNIQUE,R.UNIQUE,R.UNIQUE]]

var t3_expansion_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1),\
						Vector2(-1,-1),Vector2(1,1),Vector2(1,-1),Vector2(-1,1),\
						Vector2(-2,0),Vector2(2,0),Vector2(0,-2),Vector2(0,2),\
						Vector2(-2,-2),Vector2(2,2),Vector2(2,-2),Vector2(-2,2),\
						Vector2(-3,0),Vector2(3,0),Vector2(0,-3),Vector2(0,3),\
						Vector2(-3,-2),Vector2(3,2),Vector2(-2,-3),Vector2(2,3),
						Vector2(3,-2),Vector2(-3,2),Vector2(2,-3),Vector2(-2,3)]
var t3_expansion_rarities = [R.RARE,R.RARE,R.RARE,R.RARE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,\
						R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.ELITE,R.ELITE,R.ELITE,R.ELITE,\
						R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,\
						R.UNIQUE]

var zonelists = [t0_cross_tileoffset,t1_grid3_tileoffset,t2_edge8_tileoffset,t2_edge8_tileoffset,t3_expansion_tileoffset]
var zonerarities = [t0_cross_rarities,t1_grid3_rarities,t2_edge8_rarities,t2_5_rarities,t3_expansion_rarities]

var dropzone_scene = preload("res://Crafting/tile_dropzone.tscn")

func set_dropzones(Tier:gridTier):
	for n in $DROPZONES.get_children():
		$DROPZONES.remove_child(n)
	var coords = []
	var rarities = zonerarities[Tier]
	for tile in zonelists[Tier]:
		coords.append(middle_coord+(tile*Vector2(32,32)))
	coords.append(middle_coord)
	var i = -1
	for pos in coords:
		i+=1
		var zone = dropzone_scene.instantiate()
		zone.global_position = pos
		zone.rarity = rarities[i]
		
		pass
