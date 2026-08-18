extends Node2D

@export var finalised := false

enum gridTier {T0,T1,T2,T2_5,T3}
enum R {BASIC,RARE,ELITE,UNIQUE}

const middle_coord = Vector2(320,180)

var t0_cross_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1)]
var t0_cross_rarities = [R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.RARE]

var t1_grid3_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1),\
						Vector2(-1,-1),Vector2(1,1),Vector2(1,-1),Vector2(-1,1)]
var t1_grid3_rarities = [R.RARE,R.RARE,R.RARE,R.RARE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.ELITE]

var t1_grid3_rarities_unique = [R.RARE,R.RARE,R.RARE,R.RARE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.UNIQUE]

var t2_edge8_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1),\
						Vector2(-1,-1),Vector2(1,1),Vector2(1,-1),Vector2(-1,1),\
						Vector2(-2,0),Vector2(2,0),Vector2(0,-2),Vector2(0,2),\
						Vector2(-2,-2),Vector2(2,2),Vector2(2,-2),Vector2(-2,2)]
var t2_edge8_rarities = [R.RARE,R.RARE,R.RARE,R.RARE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,\
						R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.ELITE,R.ELITE,R.ELITE,R.ELITE,R.UNIQUE]

var t2_5_rarities = [R.ELITE,R.ELITE,R.ELITE,R.ELITE,R.RARE,R.RARE,R.RARE,R.RARE,\
						R.RARE,R.RARE,R.RARE,R.RARE,R.UNIQUE,R.UNIQUE,R.UNIQUE,R.UNIQUE,R.UNIQUE]

var t3_expansion_tileoffset = [Vector2(-1,0),Vector2(1,0),Vector2(0,-1),Vector2(0,1),\
						Vector2(-1,-1),Vector2(1,1),Vector2(1,-1),Vector2(-1,1),\
						Vector2(-2,0),Vector2(2,0),Vector2(0,-2),Vector2(0,2),\
						Vector2(-2,-2),Vector2(2,2),Vector2(2,-2),Vector2(-2,2),\
						Vector2(-4,0),Vector2(4,0),Vector2(0,-4),Vector2(0,4),\
						Vector2(-3,-2),Vector2(3,2),Vector2(-2,-3),Vector2(2,3),
						Vector2(3,-2),Vector2(-3,2),Vector2(2,-3),Vector2(-2,3)]
var t3_expansion_rarities = [R.RARE,R.RARE,R.RARE,R.RARE,R.BASIC,R.BASIC,R.BASIC,R.BASIC,\
						R.BASIC,R.BASIC,R.BASIC,R.BASIC,R.ELITE,R.ELITE,R.ELITE,R.ELITE,\
						R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,R.RARE,\
						R.UNIQUE]

@onready var bg_0 = $TileMapLayer_Base/TileMapLayer_Slots0
@onready var bg_1 = $TileMapLayer_Base/TileMapLayer_Slots1
@onready var bg_2 = $TileMapLayer_Base/TileMapLayer_Slots2
@onready var bg_3 = $TileMapLayer_Base/TileMapLayer_Slots3

var zone_bgs = [bg_0,bg_1,bg_1,bg_2,bg_2,bg_3]
var zonelists = [t0_cross_tileoffset,t1_grid3_tileoffset,t1_grid3_tileoffset,t2_edge8_tileoffset,t2_edge8_tileoffset,t3_expansion_tileoffset]
var zonerarities = [t0_cross_rarities,t1_grid3_rarities,t1_grid3_rarities_unique,t2_edge8_rarities,t2_5_rarities,t3_expansion_rarities]

@export var t1_forceboss_recipe:Array[DUNGEON_CRAFTING_TILE_DATA]
@export var t1_fireboss_recipe:Array[DUNGEON_CRAFTING_TILE_DATA]
@export var t1_waterboss_recipe:Array[DUNGEON_CRAFTING_TILE_DATA]
@export var t1_earthboss_recipe:Array[DUNGEON_CRAFTING_TILE_DATA]
@export var t1_airboss_recipe:Array[DUNGEON_CRAFTING_TILE_DATA]
@export var treasure_vault_recipe:Array[DUNGEON_CRAFTING_TILE_DATA]

var preset_recipes = [t1_fireboss_recipe,t1_waterboss_recipe,t1_earthboss_recipe,t1_airboss_recipe,t1_forceboss_recipe,treasure_vault_recipe]

func check_for_preset_recipes():
	#print(t1_forceboss_recipe)
	#print("predef",preset_recipes[4])
	preset_recipes = [t1_forceboss_recipe,treasure_vault_recipe] #t1_fireboss_recipe,t1_waterboss_recipe,t1_earthboss_recipe,t1_airboss_recipe,
	#print("postdef",preset_recipes[4])
	var valid_recipe = false
	var zones = $DROPZONES.get_children()
	var return_preset
	for recipe in preset_recipes:

		var preset_list_tileID = [] #tile ids
		var zonedata_list = []
		var zone_tilelID = []
		
		for zone:DropZone in $DROPZONES.get_children():
			zonedata_list.append(zone.CRAFTING_TILE_DATA)
		#if recipe == preset_recipes[-1]:
		print("zonesdata:",zonedata_list,"\nrecipe:",recipe)
		
		for i in $DROPZONES.get_child_count():
			if i <= recipe.size()-2:
				if recipe[i] != null:
					preset_list_tileID.append(recipe[i].TILE_ID)
				else:
					preset_list_tileID.append('<null>')
				if $DROPZONES.get_child(i).CRAFTING_TILE_DATA != null:
					zone_tilelID.append($DROPZONES.get_child(i).CRAFTING_TILE_DATA.TILE_ID)
				else:
					zone_tilelID.append('<null>')
		print('z_tileID:',zone_tilelID,"\nrecipe_tileID:",preset_list_tileID)
			#print("zone tileID:",zone_list[i].CRAFTING_TILE_DATA.TILE_ID," recipe tileID:",recipe[i].TILE_ID)
		
		#unindent this latervvvvv
		for j in recipe.size() - 2:
			print(j)
			if recipe[j] != null and recipe[j] != zonedata_list[j]:
				print(zonedata_list[j]," != ",recipe[j],'\n',zone_tilelID[j]," != ",preset_list_tileID[j])
				break
			elif j == recipe.size() - 3:
				valid_recipe = true
				return_preset = recipe.duplicate()
				print('is valid recipe')
				break
			else:
				print('not end of recipe')
			
	if valid_recipe:
		print('returning preset data now')
		return return_preset
	else:
		return null
#		var zone_index = 0

		#var data:DUNGEON_CRAFTING_TILE_DATA #stored data in dropzones
		#for tile_resource in recipe:
		#	data = zones[zone_index].CRAFTING_TILE_DATA
		#	preset_list.append(tile_resource.TILE_ID)
		#	if zone_index <= zones.get_size()-1:
		#		if data != tile_resource and data != null:
		#			valid_recipe = false
		#			break
		#	else:
		#		return_preset = recipe#[-1] #the actual data we care about being returned.
		#		valid_recipe = true
		#if valid_recipe:
		#	print("this should be a valid recipe")
		#	break
		#print(preset_list)
	#if valid_recipe:
	#	return return_preset
	#else:
	#	return null

var dropzone_scene = preload("res://Crafting/tile_dropzone.tscn")

func set_dropzones(Tier:gridTier):
	grid_level = Tier
	for n:DropZone in $DROPZONES.get_children():
		#n.remove_data()
		#await get_tree().create_timer(0.1).timeout
		n.queue_free()
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
		$DROPZONES.add_child(zone)
		pass
	#await get_tree().create_timer(0.8).timeout
	for n in zone_bgs:
		print(n)
		if n == zone_bgs[Tier]:
			n.visible = true
		else:
			n.visible = false

@export var grid_level = 0

func _ready() -> void:
	grid_level = clampi(grid_level,0,5)
	bg_0 = $TileMapLayer_Base/TileMapLayer_Slots0
	bg_1 = $TileMapLayer_Base/TileMapLayer_Slots1
	bg_2 = $TileMapLayer_Base/TileMapLayer_Slots2
	bg_3 = $TileMapLayer_Base/TileMapLayer_Slots3
	zone_bgs = [bg_0,bg_1,bg_1,bg_2,bg_2,bg_3]
	print(zone_bgs)
	set_dropzones(grid_level)

func change_data(data:DUNGEON_CRAFTING_TILE_DATA,adding:bool):
	$TileInventory.change_data(data,adding)
	pass


func _on_button_pressedPLUS() -> void:
	for n:DropZone in $DROPZONES.get_children():
		if n.slot_filled:
			n.remove_data()
	if grid_level == 3:
		if $TileInventory.TileID_NamedInventory[-3][1] > 0:
			set_dropzones(clampi(grid_level+1,0,5))
		else:
			set_dropzones(clampi(grid_level+2,0,5))
	else:
		set_dropzones(clampi(grid_level+1,0,5))
	pass # Replace with function body.


func _on_button_pressedMINUS() -> void:
	for n:DropZone in $DROPZONES.get_children():
		if n.slot_filled:
			n.remove_data()
	if grid_level == 5:
		if $TileInventory.TileID_NamedInventory[-3][1] > 0:
			set_dropzones(clampi(grid_level-1,0,5))
		else:
			set_dropzones(clampi(grid_level-2,0,5))
	else:
		set_dropzones(clampi(grid_level-1,0,5))
	pass # Replace with function body.


func _on_texture_button_pressed() -> void:
	self.visible = false
	self.position = Vector2(-672,-388)
