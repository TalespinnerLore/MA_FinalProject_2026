extends Sprite2D
class_name DungeonCraftingTile

@export var data:DUNGEON_CRAFTING_TILE_DATA

@export var num_in_inventory = 2

var is_draggable = false

func drag_failed():
	print("DRAG FAILED")
	num_in_inventory+=1
	check_visible()

func check_visible():
	if num_in_inventory > 0:
		self.visible = true
	else:
		self.visible = false

func _ready() -> void:
	self.frame = data.TILE_ID
	check_visible()

const DragDropPlaceholder = preload("res://Utility/Misc/DragDrop_Placeholder.tscn")

func _process(delta: float) -> void:
	if is_draggable and ! Global.is_DraggingObject:
		if Input.is_action_just_pressed("LeftClick"):
			$ColorRect.visible = false
			is_draggable = false
			var cursor_offset = get_global_mouse_position()-self.global_position
			var Drag_Drop = DragDropPlaceholder.instantiate()
			Drag_Drop.picked_up(texture,hframes,vframes,frame,data.rarity,data,self)
			Drag_Drop.global_position = cursor_offset
			get_tree().root.add_child(Drag_Drop)
			num_in_inventory -= 1
			check_visible()


func _on_area_2d_mouse_entered() -> void:
	if not Global.is_DraggingObject:
		is_draggable = true
		$ColorRect.visible = true
		print("isdraggable: ",is_draggable)
	

func _on_area_2d_mouse_exited() -> void:
	#print("MOUSE EXIT")
	if not Global.is_DraggingObject:
		is_draggable = false
		#scale = Vector2(1,1)
		$ColorRect.visible = false
		print("isdraggable: ",is_draggable)
