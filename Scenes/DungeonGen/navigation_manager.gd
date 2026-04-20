class_name NavigationManager
extends Node2D

@onready var tilemaplayer_ref:Dungeon_Floor = get_tree().get_first_node_in_group("TILEMAP")
@onready var env_object_manager_ref:EnvironmentObjectManager = get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")
@onready var unit_manager_ref:Unit_Manager =  get_tree().get_first_node_in_group("UNIT_MANAGER")

########UNIT DATA########
var unit_locations:Array[Vector2i]

func notify_room_env_object(adding:bool,objectref:Node2D,tile:Vector2i):
	if adding:
		for room in ROOMS:
			if room.RoomFloor.has(tile):
				room.EnvObjectsInRoom.append(objectref)
				break
	else:
		for room in ROOMS:
			if room.RoomFloor.has(tile):
				room.EnvObjectsInRoom.erase(objectref)
				break

########ROOM DATA########
var ROOMS:Array[NavigationRoom]
var ROOMS_with_player:Array[NavigationRoom]
######TILEMAP CELLS######
var cells_Wall = []    ##
var cells_Ground = []  ##
var cells_Water = []   ##
var cells_Lava = []    ##
var cells_Air = []     ##
					   ##
var has_water := false ##
var has_lava := false  ##
var has_air := false   ##
#########################

######ASTAR2D CODE#######
var astar_grid_standard:AStarGrid2D = AStarGrid2D.new()
var astar_grid_waterwalk:AStarGrid2D = AStarGrid2D.new()
var astar_grid_lavawalk:AStarGrid2D = AStarGrid2D.new()
var astar_grid_airwalk:AStarGrid2D = AStarGrid2D.new()
var grids = [astar_grid_standard,astar_grid_waterwalk,astar_grid_lavawalk,astar_grid_airwalk]

var grid_size:Vector2i = Vector2i(40,40)
var path_array:Array[Vector2i] = [] #storage var for path whenever a path is needed.

func set_up_grid() -> void:
	grid_size = Vector2i(tilemaplayer_ref.get_used_rect().size)
	var index = -1
	for grid in grids:
		index +=1
		var astar_grid:AStarGrid2D = grids[index]
		astar_grid.region = Rect2i(Vector2i(0,0),grid_size)
		astar_grid.cell_size = tilemaplayer_ref.tile_set.tile_size
		astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
		astar_grid.update()
		
		var unpassable:int = grid_size.x * grid_size.y
		
		for tile in tilemaplayer_ref.get_used_cells():
			var cell_path_cost:int = 0
			if tilemaplayer_ref is Dungeon_Floor:
				match tilemaplayer_ref.what_is_this_tile(tile.x,tile.y):
					'WALL':
						cell_path_cost = unpassable
					'ROOM_WALL':
						cell_path_cost = unpassable
					'FLOOR':
						cell_path_cost = 1
					'WATER':
						if index == 1 or index == 3:
							cell_path_cost = 2
						else:
							cell_path_cost = unpassable
					'LAVA':
						if index == 2 or index == 3:
							cell_path_cost = 2
						else:
							cell_path_cost = unpassable
					'AIR':
						if index == 3:
							cell_path_cost = 2
						else:
							cell_path_cost = unpassable
			
			if cell_path_cost == unpassable or check_for_unpassable_objects(tile):
				astar_grid.set_point_solid(tile)
			else:
				astar_grid.set_point_weight_scale(tile,cell_path_cost)

func check_for_unpassable_objects(tile):
	if is_instance_valid(env_object_manager_ref):
		if env_object_manager_ref.unpassable_tiles.has(tile):
			return true
	#if is_instance_valid(unit_manager_ref):
	#	if unit_manager_ref.unpassable_tiles.has(tile):
	#		return true
	return false

func get_valid_path(start_pos:Vector2i,end_pos:Vector2i,grid_index) -> Array[Vector2i]:
	path_array.clear()
	var astar_grid:AStarGrid2D = grids[grid_index]
	for point in astar_grid.get_point_path(start_pos,end_pos,true):
		var current_point = Vector2i(point)
		current_point += tilemaplayer_ref.tile_set.tile_size / 2
		path_array.append(current_point)	
	return path_array

#########################

####ROOM-TO-ROOM PATHS###

func find_room_to_room_paths():
	if ROOMS.size() > 1:
		for room in ROOMS:
			for doorway in room.RoomDoors:
				var possible_paths_g = []
				var possible_paths_w = []
				var possible_paths_l = []
				var possible_paths_a = []
				for other_room in ROOMS:
					if other_room != room:
						possible_paths_g.append(get_valid_path(doorway,other_room.RoomCenter,0))
						if has_water:
							possible_paths_w.append(get_valid_path(doorway,other_room.RoomCenter,1))
						if has_lava:
							possible_paths_l.append(get_valid_path(doorway,other_room.RoomCenter,2))
						if has_air:
							possible_paths_a.append(get_valid_path(doorway,other_room.RoomCenter,3))
				possible_paths_g.sort_custom(sort_array_size_ascending)
				room.ground_paths.append(possible_paths_g[0])
				if has_water:
					possible_paths_w.sort_custom(sort_array_size_ascending)
					room.ground_paths.append(possible_paths_w[0])
				if has_lava:
					possible_paths_l.sort_custom(sort_array_size_ascending)
					room.ground_paths.append(possible_paths_l[0])
				if has_air:
					possible_paths_a.sort_custom(sort_array_size_ascending)
					room.ground_paths.append(possible_paths_a[0])


func sort_array_size_ascending(a:Array,b:Array):
	if a.size() < b.size():
		return true
	return false

#########################

#####SPAWN NEW ROOMS#####
const room_scene = preload("res://Scenes/DungeonGen/navigation_room_scene.tscn")

func spawn_new_room(RoomOrigin,RoomSize,RoomDoors,RoomFloor):
	var room = room_scene.instantiate()
	#print("origin:",RoomOrigin)
	room.position = RoomOrigin*Vector2i(32,32)
	#print("position:",room.position," ","coord:",Global.pos_to_grid(room.global_position+Vector2(16,16)))
	room.RoomOrigin = RoomOrigin
	room.RoomCenter = Vector2i(int(RoomOrigin.x/2),int(RoomOrigin.y/2))
	room.RoomSize = RoomSize
	room.RoomDoors.append_array(RoomDoors)
	room.RoomFloor.append_array(RoomFloor)
	add_child(room)
	var new_room = get_child(-1)
	new_room.init()
	ROOMS.append(new_room)

#########################

func init():
	tilemaplayer_ref = get_tree().get_first_node_in_group("TILEMAP")
	if is_instance_valid(tilemaplayer_ref):
		cells_Wall = tilemaplayer_ref.cells_Wall
		cells_Ground = tilemaplayer_ref.cells_Ground
		cells_Water = tilemaplayer_ref.cells_Water
		cells_Lava = tilemaplayer_ref.cells_Lava
		cells_Air = tilemaplayer_ref.cells_Air
		if cells_Water.size() > 0:
			has_water = true
		if cells_Lava.size() > 0:
			has_lava = true
		if cells_Air.size() > 0:
			has_air = true
		set_up_grid()
		for room in tilemaplayer_ref.Rooms:
			spawn_new_room(room[0].position,room[0].size,room[3],room[1])
	else:
		push_error("Invalid reference to TileMapLayer_DungeonFloor")
#Rect2i, floor, walls, doors
#########################


func _ready() -> void:
	#grid_size = Vector2i(tilemaplayer_ref.Width_X,tilemaplayer_ref.Height_Y)
	#tilemap_ref = get_tree().get_first_node_in_group("TILEMAP")
	pass
