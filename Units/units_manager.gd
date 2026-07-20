class_name Unit_Manager
extends Node2D

#spawn units
#inject dependancies
#listen for events
#win/lose
#turn complete

######## SIGNALS ########

signal reached_goal(found_stairs)
signal player_died(can_revive)

#########################
##### GROUPS & UNITS #####

var tilemaplayer_ref:Dungeon_Floor

var all_groups: =[]# Array[Unit_Group] = []

var current_group: Node
var current_group_index: int = -1
var previous_group_index: int = -1
var turn_counter = 0

var player_dead = false
var monster_house = false

@export var player_loc:Vector2i #= Active_Units[0].self_coords
@export var spawn_tiles:Array[Vector2i] = []

@export var temp_miniboss:StatComponent

@export var Active_Units:Array[Unit_Instance]
@export var nav_manager_ref:NavigationManager
@export var dialogue_manager_ref:DialogueManager
@export var env_manager_ref:EnvironmentObjectManager

var player_spawnpoint:Vector2i
##########################
########## INIT ##########

func init() -> void:
	print("UNIT MANAGER INITIALIZED, floor ",DungeonData.current_floor,\
	"maxfloors: ",DungeonData.max_floors," enem cap:",DungeonData.max_wandering_units)
	tilemaplayer_ref = get_tree().get_first_node_in_group("TILEMAP")
	nav_manager_ref = get_tree().get_first_node_in_group("NAVIGATION_MANAGER") 
	dialogue_manager_ref = get_tree().get_first_node_in_group("DIALOGUE_MANAGER")
	env_manager_ref = get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")
	print("spawn tiles:",spawn_tiles)
	get_room_spawn_tiles()
	print("spawn tiles:",spawn_tiles)
	for child in get_children():
		child.init()
		all_groups.append(child)
		child.AbilityUsed.connect(_process_ability)
		child.group_turn_completed.connect(_on_turn_complete)
		#child.defeated.connect(_on_group_defeated)
	if monster_house:
		monster_house = false
		for i in range(DungeonData.max_wandering_units):
			spawn_unit(all_groups[1])
	if DungeonData.current_floor == DungeonData.max_floors:
		for group:Unit_Group in all_groups:
			if group.is_player_controlled == false:
				group.dungeon_boss_defeated.connect(_on_boss_defeat)
		print("final floor[0na,1mini/boss,2monhouse]",DungeonData.final_floor)
		#all_groups[0].get_child(0).global_position = Global.grid_to_pos(tilemaplayer_ref.player_spawnpoint)
		match DungeonData.final_floor:
			DungeonData.FINAL_FLOOR.N_A:
				print("dungeon boss NA")
			DungeonData.FINAL_FLOOR.MON_HOUSE:
				print("monster house boss level")
				for i in range(DungeonData.max_wandering_units):
					spawn_unit(all_groups[1])
			DungeonData.FINAL_FLOOR.MINI_BOSS:
				print("dungeon miniboss spawn")
				spawn_specific_unit(all_groups[1],DungeonData.boss,tilemaplayer_ref.boss_spawn_loc)
			DungeonData.FINAL_FLOOR.BOSS:
				print("dungeon boss spawn")
				spawn_specific_unit(all_groups[1],DungeonData.boss,tilemaplayer_ref.boss_spawn_loc)
	
	Active_Units[0].get_self_coords()
	#to make the player have the correct location data before moving once.
	_step_turn() 

func _on_boss_defeat():
	#on the final floor, when all enemies defeated, show portal and enable collision.
	print("unitmanager; on boss defeat triggered")
	DungeonData.max_wandering_units = 0
	env_manager_ref.portal_visibility()

func _ready():
	#init()
	#_step_turn()
	pass

##########################
####### SPAWN UNIT #######

const unit_scene = preload("res://Units/unit.tscn")

func spawn_unit(group:Unit_Group):
	
	var new_unit:Unit_Instance = unit_scene.instantiate()
	if group.is_player_controlled == false:
		var rare_chance = randf()
		if rare_chance > 0.95:
			print("spawn_unit; RE:",DungeonData.Rare_Enemies)
			new_unit.UnitStats = DungeonData.Rare_Enemies.pick_random()
		else:
			#print(DungeonData.Common_Enemies)
			print("spawn_unit; CE:",DungeonData.Common_Enemies)
			new_unit.UnitStats = DungeonData.Common_Enemies.pick_random()
#		print("Basicattack", new_unit.UnitStats)
		var placing = false
		var emergency_index = 0
		while placing == false:
			placing = true
#			print("null test tilemap ref",tilemaplayer_ref)
			var try = spawn_tiles.pick_random()
			#print(" try coord:",try)#"all:",tilemaplayer_ref.AllRoomTiles,
			if Active_Units.size() > 0:
				emergency_index += 1
				player_loc = Active_Units[0].self_coords
				#print(Active_Units,"is player? ",Active_Units[0].Team,Active_Units[0].self_coords)
				#print(player_loc,try)
				
				for unit in Active_Units:
					if is_instance_valid(unit):
						if unit.self_coords == try:
							placing = false
				if try.x > player_loc.x - 10 and try.x < player_loc.x + 10:
					print("failed in x")
					placing = false
				elif try.y > player_loc.y - 6 and try.y < player_loc.y + 6:
					print("failed in y")
					placing = false
				print("ei:",emergency_index)
				if emergency_index > 30: #emergency infinite loop break
					new_unit.position = Global.grid_to_pos(try)
					break
				
			new_unit.position = Global.grid_to_pos(try)
		new_unit.UnitLevel = DungeonData.AREA_LEVEL+DungeonData.UNIT_LEVEL_Boost
		Active_Units.append(new_unit)
		group.add_child(new_unit)
		group.get_child(-1).init(group.is_player_controlled)
	pass

func spawn_specific_unit(group:Unit_Group,unitdata:StatComponent,tile:Vector2i):
	var new_unit:Unit_Instance = unit_scene.instantiate()
	new_unit.UnitStats = unitdata
	new_unit.position = Global.grid_to_pos(tile)
	new_unit.UnitLevel = DungeonData.AREA_LEVEL+DungeonData.UNIT_LEVEL_Boost
	Active_Units.append(new_unit)
	group.add_child(new_unit)
	print("spawn spec unit; name:",unitdata.UnitName)
	group.get_child(-1).init(group.is_player_controlled)
	pass

func get_room_spawn_tiles():
	spawn_tiles.clear()
	print("roomtiles:",tilemaplayer_ref.AllRoomTiles)
	print("groundtiles:",tilemaplayer_ref.cells_Ground)
	for tile in tilemaplayer_ref.AllRoomTiles:
		if tilemaplayer_ref.cells_Ground.has(tile):
			spawn_tiles.append(tile)
	pass
###########################
########## TURNS ##########

func _step_turn() -> void:
	if ! player_dead:
		var holding_variable = 0
		holding_variable = current_group_index
		current_group_index = wrapi(current_group_index + 1, 0, all_groups.size())
	#	print("group index: ",current_group_index)
		previous_group_index = holding_variable
		current_group = all_groups[current_group_index]
	#	print("group: ",current_group)
		if current_group.get_active_units().size() <= 0:
			print("empty group, skip")
			#SPAWN ENEMY IF NOT PLAYER_CONTROLLED, ELSE, STOP FUNCTION
			_step_turn()
			return
			#print("breaks here")
		if current_group_index == previous_group_index:
			push_error('Only one group found')
		#	break
		_begin_turn()

func _begin_turn() -> void:
	
	turn_counter += 1
	#print("TURN COUNTER - ",turn_counter) #vvv triggers every 30 player turns/steps vvv
	if turn_counter%60 == 0 and $Enemy_Group.get_child_count() < DungeonData.max_wandering_units:
		spawn_unit(all_groups[1]) #enemy group
		#print("Current enemies: ",$Enemy_Group.get_child_count(),", Max enemies: ",DungeonData.max_wandering_units)
#	print("HITS MANAGER BEGIN TURN")
	current_group.take_turn_team()


func _on_turn_complete() -> void:
#	print('manager on group turn complete hit')
	_step_turn()
	return

##########################

func _on_group_defeated(_is_player: bool):
	if _is_player:
		get_tree().change_scene_to_file("res://Crafting/TowerCrafting.tscn")
	pass #you loseQ get booted out of the dungeon



const Ability_vfx = preload("res://Objects/AbilityVFX.tscn")

func _process_ability(Ability:AbilityData,Source):
	print(Source.UnitStats.UnitName," uses ",Ability.ability_name,"!")
	dialogue_manager_ref.show_unit_using_ability(Source.UnitStats.UnitName,Ability.ability_name)
	var hit_tiles = calc_hit_tiles(Ability.targeting,Ability.range+Source.Range_Boost,Source.facing,Source.self_coords)
	#print("HITTILES",hit_tiles)
	var units_to_check:Array[Unit_Instance]
	var does_pierce = false
	var hits_nothing = true
	if Ability.targeting != 0: #FRONT
		does_pierce = true
#	print("Hit Tiles: ",hit_tiles)
	for tile in hit_tiles:
		#print("Hit Tile: ",tile)
		#if does_pierce:
		var vfx = Ability_vfx.instantiate()
		vfx.texture = Ability.vfx
#		print(Ability.vfx.get_size())
		vfx.position = Global.grid_to_pos(tile)
		$"../VFX".add_child(vfx)
		for group in all_groups:
			#print("Group: ",group.name)
			for child in group.get_children():
				#print("Unit: ",child,", Coords: ",child.self_coords)
				if Vector2i(child.self_coords) == Vector2i(tile): # vvv ENEMY, ALLY, ANY, SELF
					if Source.Team == child.Team and Ability.valid_target != 0: 
					#if same team and can hit ally, any or self, do hit.
						child.ability_effect_calculations(Ability,Source)
						hits_nothing = false
						if ! does_pierce:
							#print("not pierce swewsvsdivusiuvhsdivhs8dhv")
							var new_vfx = Ability_vfx.instantiate()
							new_vfx.position = Global.grid_to_pos(tile)
							$"../VFX".add_child(new_vfx)
							break
						else:
							pass
							#print("IS pierce swewsvsdivusiuvhsdivhs8dhv")
					elif Source.Team != child.Team and Ability.valid_target != 1 and Ability.valid_target != 3:
					#if different team and can hit enemy or any, do hit.
						child.ability_effect_calculations(Ability,Source)
						hits_nothing = false
						if ! does_pierce:
								#print("not pierce swewsvsdivusiuvhsdivhs8dhv")
								var neww_vfx = Ability_vfx.instantiate()
								neww_vfx.global_position = Global.grid_to_pos(tile)
								$"../VFX".add_child(neww_vfx)
								break
	if hits_nothing:
		print("that hit nothing")
	#	if 
	#	await Source.waiting_on_dialogue
		dialogue_manager_ref.hit_nothing()
	pass


	


@onready var tilegrid = $"../TileMapLayer"########GET REFERENCE TO GRID

func calc_hit_tiles(targeting:int, range:int, facing:Vector2i, source_coord:Vector2i):
	var targettypes = ["Front", "Line", "Cone", "Circle", "Self"]
	var target = targettypes[targeting]
	#print("Targeting: ",target,"Range: ",range,"Facing: ",facing,"SourceCoord",source_coord)
	var relative_tiles = []
	#print(targeting,target)
	match target: #Front, Line, Cone, Circle, Specify
		"Front":
			for i in range:
				relative_tiles.append(facing*(i+1))
		"Line":
			var fin = false
			var i = 0
			while fin == false:
				i+=1
				var tile = source_coord+(facing*i)
	#			print("LINE_TILE: ",tile)
				var tile_type = tilegrid.what_is_this_tile(tile.x,tile.y)
	#			print(tile_type)
				if  tile_type == 'FLOOR' or tile_type == 'WATER': #if the next tile isn't a Wall, continue.
					relative_tiles.append((facing*i))
				else:
					fin = true
			pass
		"Cone": #expanding cone of tiles, tight if straight, in a checker pattern in diagonal.
			if facing.length() > 1: #<-diagonal cone
				for r in range:
					relative_tiles.append(facing*(r+1))#
					if r > 0:
						for step in r:
							relative_tiles.append(facing*(r+1) + Vector2i(facing.x,-facing.y)*(step+1))
							relative_tiles.append(facing*(r+1) + Vector2i(-facing.x,facing.y)*(step+1))
							#relative_tiles.append(facing*(r) + Vector2i(facing.x,step))
							#relative_tiles.append(facing*(r) + Vector2i(step,facing.y))
			else: #STRAIGHT-ON CONE
				var cone_spread = Vector2i.ZERO
				for r in range:
					relative_tiles.append(Vector2i(facing*(r+1)))
					if facing.x != 0:
						cone_spread = Vector2i(0,1)
					else:
						cone_spread = Vector2i(1,0)
					if r > 0:
						for step in r:
							relative_tiles.append(facing*(r+1) + cone_spread*(step+1))
							relative_tiles.append(facing*(r+1) - cone_spread*(step+1))
			pass
		"Circle":
			relative_tiles = Circular_Area(range,Vector2i.ZERO,false)
			relative_tiles.erase(source_coord)
			pass
		"Self":
			print("SELF TARGET")
			relative_tiles.append(Vector2i(0,0))
			pass
	#print("Sourcecoord: ",source_coord,"relative tiles: ",relative_tiles)
	var real_tiles = []
	for tile in relative_tiles:
		real_tiles.append(tile+source_coord)
		#print("real_tiles: ",real_tiles)
	#print("+sourcecoord",relative_tiles)
	return(real_tiles)

func Circular_Area(radius,Tile_Location,Relative):
	var side_erase = floori(((radius*2)+1)/4)
	side_erase = clampi(side_erase,1,radius)
	var bottom_corner = Tile_Location+Vector2i(-radius,-radius)
	var top_corner = Tile_Location+Vector2i(radius,radius)
	var x_corner = Tile_Location+Vector2i(radius,-radius)
	var y_corner = Tile_Location+Vector2i(-radius,radius)
	var circle_tiles = []#[bottom_corner,top_corner,x_corner,y_corner]
	for x in range(Tile_Location.x-radius, Tile_Location.x+radius+1):
		for y in range(Tile_Location.y-radius, Tile_Location.y+radius+1):
			circle_tiles.append(Vector2i(x,y))
	var done = false
	while done == false:
		for i in side_erase:
			circle_tiles.erase(bottom_corner+Vector2i(i,0))
			circle_tiles.erase(bottom_corner+Vector2i(0,i))
			circle_tiles.erase(top_corner+Vector2i(-i,0))
			circle_tiles.erase(top_corner+Vector2i(0,-i))
			circle_tiles.erase(y_corner+Vector2i(i,0))
			circle_tiles.erase(y_corner+Vector2i(0,-i))
			circle_tiles.erase(x_corner+Vector2i(-i,0))
			circle_tiles.erase(x_corner+Vector2i(0,i))
		
		side_erase -= 2
		clampi(side_erase,0,999)
		if side_erase <= 0:
			done = true
		else:
			bottom_corner += Vector2i(1,1)
			top_corner += Vector2i(-1,-1)
			x_corner += Vector2i(-1,1)
			y_corner += Vector2i(1,-1)
		#done = true
	if Relative == true:
		return circle_tiles
	else:
		return circle_tiles

#######################################
############ OUTDATED CODE ############
#############VVVVVVVVVVVVV#############

func _process_attack(ActionDef,facing,source_coord,attack_source_stats): #DEPRECIATED
	var relative_tiles = calc_hit_tiles(ActionDef["targeting"],ActionDef["range"],facing,source_coord)
	var tiles_to_check = []
	for tile in relative_tiles:
		tiles_to_check.append(tile+source_coord)
	if ActionDef["valid_target"] == 0 or ActionDef["valid_target"] == 2: #check if hits Enemy or Any
		for unit in $Enemy_Group.get_children():
			if unit.calc_hit_crit()[0]:
				if ActionDef["damaging"]:
					unit.calc_damage_taken(attack_source_stats)
				for status in ActionDef["inflicts_status"]:
					unit.inflict_status(status)
	if ActionDef["valid_target"] == 1 or ActionDef["valid_target"] == 2: #check if hits Ally or Any
		pass
