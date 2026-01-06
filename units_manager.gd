class_name Unit_Manager
extends Node2D

#spawn units
#inject dependancies
#listen for events
###win/lose
###turn complete

signal reached_goal(found_stairs)
signal player_died(can_revive)

var all_groups: Array[Unit_Group] = []

var current_group: Node
var current_group_index: int = 0
var previous_group_index: int = -1

@export var Active_Units = []

func init() -> void:
	for child in get_children():
		child.init()
		all_groups.append(child)
		child.attack.connect(_process_attack)
		child.turn_complete.connect(_on_turn_complete)
		child.defeated.connect(_on_group_defeated)
	 	
	pass

func _step_turn() -> void:
	while true:
		current_group_index = wrapi(current_group_index + 1, 0, all_groups.size())
		current_group = all_groups[current_group_index]
		if current_group.get_active_units().size() > 0:
			break
		#prevents lockup, supposedly
		if current_group_index == previous_group_index:
			push_error('Only one group found')
			break
		_begin_turn()

func _begin_turn() -> void:
	current_group.take_turn()

# {"Default Attack (Physical)":
#								{"ability_name": 'Default Attack (Physical)',
#								"valid_target": 0, #Enemy, Ally, Any
#								"targeting": 0, 
#								"range": 1,
#								"damage_type": 0,
#								"damaging": true,
#								"inflicts_status": [0]},

func _process_attack(ActionDef,facing,source_coord,attack_source_stats):
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

var tilegrid ########GET REFERENCE TO GRID

func calc_hit_tiles(targeting:String, range:int, facing:Vector2i, source_coord:Vector2i):
	var relative_tiles = []
	match targeting: #Front, Line, Cone, Circle, Specify
		"Front":
			for i in range:
				relative_tiles.append(facing*(i+1))
		"Line":
			var fin = false
			var i = 0
			while fin == false:
				i+=1
				if tilegrid.get_terrain(source_coord+facing*i) != 0: #if the next tile isn't a Wall, continue.
					relative_tiles.append(source_coord+facing*i)
				else:
					fin = true
			pass
		"Cone": #expanding cone of tiles, tight if straight, in a checker pattern in diagonal.
			if facing.length() > 1:
				for r in range:
					relative_tiles.append[facing*(r+1)]#
					if r > 0:
						for step in r:
							relative_tiles.append[facing*(r+1) + Vector2i(facing.x,0)]
							relative_tiles.append[facing*(r+1) + Vector2i(0,facing.y)]
			else:
				var cone_spread = Vector2i.ZERO
				for r in range:
					relative_tiles.append[facing*(r+1)]
					if facing.x != 0:
						cone_spread = Vector2i(0,1)
					else:
						cone_spread = Vector2i(1,0)
					if r > 0:
						for step in r:
							relative_tiles.append[facing*(r+1) + cone_spread]
							relative_tiles.append[facing*(r+1) - cone_spread]
			pass
		"Circle":
			relative_tiles = Circular_Area(range,source_coord,false)
			relative_tiles.erase(source_coord)
			pass
		"Specify":
			#relative_tiles.append[target_tile]
			pass
	return(relative_tiles)

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

func _on_turn_complete() -> void:
	_step_turn()
	return

func _on_group_defeated(_is_player: bool):
	pass
