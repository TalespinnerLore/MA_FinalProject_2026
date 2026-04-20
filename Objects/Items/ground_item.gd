extends Sprite2D
class_name GroundItem

var ITEM_DATA:ItemData

var stack_size := 1

var tile_coords:Vector2i



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			Add_to_Player_Inv_stack()
			if stack_size > 0:
				Add_to_Player_Inv_slot()
		elif body.Team == body.Teams.ENEMY:
			pass


func Add_to_Player_Inv_stack():
	var inv = PlayerStats.player_inventory
	for item in inv:
		if item[0] == ITEM_DATA and item[1] < ITEM_DATA.max_stack:
			var space = ITEM_DATA.max_stack-item[1]
			if space >= stack_size:
				item[1]+=stack_size
				stack_size = 0
				queue_free()
			else:
				item[1] = ITEM_DATA.max_stack
				stack_size -= space
	pass

func Add_to_Player_Inv_slot():
	var inv = PlayerStats.player_inventory
	if inv.size() < PlayerStats.inventory_size:
		PlayerStats.player_inventory.append([ITEM_DATA,stack_size])
		queue_free()
	pass

func Attempt_Equip_to_Unit(unit:Unit_Instance):
	pass

func Attempt_Give_Unit_HoldItem(unit:Unit_Instance):
	if unit.HeldItem == null:
		unit.HeldItem = ITEM_DATA
		unit.HeldItem_stacksize = stack_size
		queue_free()
	elif unit.HeldItem == ITEM_DATA:
		var space = ITEM_DATA.max_stack-unit.HeldItem_stacksize
		if space >= stack_size:
			unit.HeldItem_stacksize+=stack_size
			stack_size = 0
			queue_free()
		else:
			unit.HeldItem_stacksize = ITEM_DATA.max_stack
			stack_size -= space
	else:
		print("Already holding an Item.")
