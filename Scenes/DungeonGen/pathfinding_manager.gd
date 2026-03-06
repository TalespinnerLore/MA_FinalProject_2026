class_name PathfindingManager
extends Node

const PATH_COST:String = 'path_cost'

var astar_grid:AStarGrid2D = AStarGrid2D.new()
var path_array:Array[Vector2i] = []

@export var tilemaplayer_ref:TileMapLayer = null

func _ready() -> void:
	set_up_grid()
	set_terrain_movement_cost()

func set_up_grid() -> void:
	astar_grid.region = tilemaplayer_ref.get_used_rect()
	astar_grid.cell_size = tilemaplayer_ref.tile_set.tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()

func set_terrain_movement_cost() -> void:
	
	for tile in tilemaplayer_ref.get_used_cells():
		var cell_data = tilemaplayer_ref.get_cell_tile_data(tile)
		var cell_path_cost:int = 0
		if tilemaplayer_ref is Dungeon_Floor:
			match tilemaplayer_ref.what_is_this_tile():
				'FLOOR':
					cell_path_cost = 0
				'WALL':
					cell_path_cost = 99
				'ROOM_WALL':
					cell_path_cost = 99
				'WATER':
					cell_path_cost = 99
		#var cell_path_cost:int = cell_data.get_custom_data(PATH_COST)
		astar_grid.set_point_weight_scale(tile,cell_path_cost)

func get_valid_path(start_pos:Vector2i,end_pos:Vector2i) -> Array[Vector2i]:
	path_array.clear()
	for point in astar_grid.get_point_path(start_pos,end_pos,true):
		var current_point = point
		current_point += tilemaplayer_ref.tile_set.tile_size / 2
		path_array.append(current_point)	
	return path_array
