class_name UniqueRoomData
extends Resource

enum NAME{TREASURE_ROOM,MINIBOSS_ROOM,FINAL_FLOOR_Generic}
enum BIOMES{test,VOLCANO,ISLAND,MESA,SKY_ISLAND}

var room_filepath = ["res://Resources/DungeonGen/UniqueRooms/Tilemaps/000_TREASURE_ROOM.tscn",\
"res://Resources/DungeonGen/UniqueRooms/Tilemaps/001_MINIBOSS_ROOM.tscn",\
"res://Resources/DungeonGen/UniqueRooms/Tilemaps/002_FINAL_FLOOR_Generic.tscn"]
@export var tilemap_name:NAME
@export var mobs_to_spawn:Array[StatComponent]
@export var items_to_spawn:Array[ItemData]
@export var key_item_list:Array[ItemData]
@export var item_num:int = 1
@export var spawn_stairs_here:bool = false
@export var spawn_extra_stairs:bool = false
@export var randomly_placed:bool = true
@export var top_left_corner_position:Vector2i
#@export var match_biome := true
@export var has_preset_spawn:=false


func get_tiles() -> String:
	print("pathprint: ",room_filepath[tilemap_name])
	var tilemap_path = room_filepath[tilemap_name]
	return tilemap_path
