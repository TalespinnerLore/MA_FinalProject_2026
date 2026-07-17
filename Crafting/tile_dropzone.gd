extends Node2D

@onready var TILE_ID = 0
enum RARITIES {BASIC,RARE,ELITE,UNIQUE}
@export var rarity:RARITIES
@export var slot_filled = false
@export var CRAFTING_TILE_ID = -1
@export var CRAFTING_TILE_DATA:DUNGEON_CRAFTING_TILE_DATA
var data_source = null
var tile_inv = null
var mouse_inside:=false
@onready var data_sprite = $filled_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame = rarity
	pass # Replace with function body.

func take_data(data:DUNGEON_CRAFTING_TILE_DATA,spritedata,data_Source):
	data_source = data_Source
	tile_inv = data_source.get_parent()
	CRAFTING_TILE_DATA = data
	print("new data: ",CRAFTING_TILE_DATA)
	data_sprite.texture = spritedata[0]
	data_sprite.hframes = spritedata[1]
	data_sprite.vframes = spritedata[2]
	data_sprite.frame = spritedata[3]
	get_parent().get_parent().change_data(CRAFTING_TILE_DATA,true)

func remove_data():
	get_parent().get_parent().change_data(CRAFTING_TILE_DATA,false)
	slot_filled = false
	data_sprite.texture = null
	if is_instance_valid(data_source):
		data_source.drag_failed()
	else:
		tile_inv.TileID_NamedInventory[CRAFTING_TILE_DATA.TILE_ID][1] += 1
	#print(data_sprite.texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_inside:
		if Input.is_action_just_pressed("RightClick"):
			remove_data()

	pass


func _on_mouse_entered() -> void:
	mouse_inside = true
	print("MOUSE IN DROPZOEN")
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	mouse_inside = false
	print("MOUSE OUT DROPAOEN")
	pass # Replace with function body.
