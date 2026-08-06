class_name NavigationRoom
extends Area2D

var NavManager_ref:NavigationManager = get_parent()

var RoomID := 0

var RoomOrigin := Vector2i.ZERO
var RoomSize := Vector2i(5,5)
var RoomCenter := Vector2i(2,2)
var RoomDoors:Array[Vector2i] = []
var RoomFloor:Array[Vector2i] = []

var UnitsInRoom:Array[Unit_Instance] = []
var ItemsInRoom:Array[Node2D] = []
var EnvObjectsInRoom:Array[Node2D] = []

var ground_paths = []
var water_paths = []
var lava_paths = []
var air_paths = []

func new_path_on_enter(body:Unit_Instance):
	ground_paths.shuffle()
	for path in ground_paths:
		if path[0] != body.last_door:
			var pathtodoor = NavManager_ref.get_valid_path_tiles(body.last_door,path[0],0)
			body.prev_path = body.path
			body.path = pathtodoor
			body.path.pop_back()
			body.path.append_array(path)
		if RoomDoors.size() < 2:
			body.prev_path = body.path
			body.path.clear()
			body.path.insert(0,body.facing + body.self_coords)
			body.path.append_array(NavManager_ref.get_valid_path_tiles(body.path[0],path[0],0))
			body.path.append_array(path)
			break

func path_check_print():
	var index = 0
	for path in ground_paths:
		index += 1
		print('ground_path #',index, " ",path)

func path_doorway_to_room(last_door:Vector2i,grid_index:int):
	var dnum
	if last_door == Vector2i(-1,-1):
		match grid_index:
			0:
				return ground_paths.pick_random()
			1:
				return water_paths.pick_random()
			2:
				return lava_paths.pick_random()
			3:
				return air_paths.pick_random()
	else:
		match grid_index:
			0:
				dnum = RoomDoors.find(last_door)
				return ground_paths[dnum]
			1:
				dnum = RoomDoors.find(last_door)
				return water_paths[dnum]
			2:
				dnum = RoomDoors.find(last_door)
				return lava_paths[dnum]
			3:
				dnum = RoomDoors.find(last_door)
				return air_paths[dnum]
	pass


func return_path_newdoor_newroom(door_coords,path_index):
	var paths = [ground_paths,water_paths,lava_paths,air_paths]
	if RoomDoors.size() > 1:
		var choices = RoomDoors.duplicate()
		choices.erase(door_coords)
		var newdoor = choices.pick_random()
		var new_path = paths[path_index][RoomDoors.find(newdoor)]
		return new_path
	elif RoomDoors.size() == 1:
		var new_path = NavManager_ref.get_valid_path(door_coords,RoomFloor.pick_random(),path_index)
		for i in range(1,4):
			var temp = NavManager_ref.get_valid_path(new_path[-1],RoomFloor.pick_random(),path_index)
			new_path.pop_back()
			new_path.append_array(temp)
		new_path.append_array(paths[path_index][0])
		return new_path
	else:
		var new_path = [door_coords]
		for i in range(3,5):
			var temp = NavManager_ref.get_valid_path(new_path[-1],RoomFloor.pick_random(),path_index)
			new_path.pop_back()
			new_path.append_array(temp)
		new_path.append_array(paths[path_index][0])
		return new_path

func init() -> void:
	NavManager_ref = get_parent()
	RoomID = NavManager_ref.get_child_count()-1
	#print("roompos: ",position," global",global_position)
	print("position:",position," ","coord:",Global.pos_to_grid(global_position+Vector2(16,16))," size:",RoomSize)
	position.x = 32*RoomOrigin.x
	position.y = 32*RoomOrigin.y
	self.scale = RoomSize
	is_init = true
	await get_tree().create_timer(3.0).timeout
	print('room init, ground paths:',ground_paths)


func _on_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		body.last_door = body.last_tile
		UnitsInRoom.append(body)
		print("New Unit Entered ",body.UnitStats.resource_path)
		if body.Team == body.Teams.PLAYER:
			print("NavManager: ",NavManager_ref)
			NavManager_ref.ROOMS_with_player.append(self)
			for unit in UnitsInRoom:
				if unit.Team == unit.Teams.ENEMY:
					unit.in_combat = true
					unit.target_unit = body
		elif body.Team == body.Teams.ENEMY:
			for unit in UnitsInRoom:
				if unit.Team == unit.Teams.PLAYER:
					body.in_combat = true
					body.target_unit = unit
					break
			new_path_on_enter(body)
	#elif body is Node2D:
	#	ItemsInRoom.append(body)
	pass # Replace with function body.

var is_init = false
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	#if ! is_init:
	#	print("premove",position)
	#	RoomOrigin = Vector2i(8,15)
	#	position.x = 32*RoomOrigin.x
	#	position.y = 32*RoomOrigin.y
	#	await get_tree().create_timer(3.0).timeout
	#	RoomSize = Vector2i(2,2)
		#init()

func _on_body_exited(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			for unit in UnitsInRoom:
				if unit.Team == unit.Teams.PLAYER:
					break
			NavManager_ref.ROOMS_with_player.erase(self)
		UnitsInRoom.erase(body)
		
	#elif body is Node2D:
	#	ItemsInRoom.erase(body)
	pass # Replace with function body.
