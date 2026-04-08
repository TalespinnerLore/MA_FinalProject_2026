class_name NavigationRoom
extends Area2D

var NavManager_ref:NavigationManager = get_parent()

var RoomOrigin := Vector2i.ZERO
var RoomSize := Vector2i(5,5)
var RoomCenter := Vector2i(2,2)
var RoomDoors:Array[Vector2i]
var RoomFloor:Array[Vector2i]

var UnitsInRoom:Array[Unit_Instance]
var ItemsInRoom:Array[Node2D]
var EnvObjectsInRoom:Array[Node2D]

var ground_paths = []
var water_paths = []
var lava_paths = []
var air_paths = []


func return_path_newdoor_newroom(door_coords,path_index):
	var paths = [ground_paths,water_paths,lava_paths,air_paths]
	if RoomDoors.size() > 1:
		var choices = RoomDoors
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
	$CollisionShape2D.scale = RoomSize
	


func _on_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		UnitsInRoom.append(body)
	#elif body is Node2D:
	#	ItemsInRoom.append(body)
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Unit_Instance:
		UnitsInRoom.erase(body)
	#elif body is Node2D:
	#	ItemsInRoom.erase(body)
	pass # Replace with function body.
