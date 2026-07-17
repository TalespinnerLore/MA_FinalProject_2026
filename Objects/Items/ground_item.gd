extends Sprite2D
class_name GroundItem

@export var ITEM_DATA:ItemData

var dropped = false

var stack_size := 1

var tile_coords:Vector2i

var is_gold:= true #temp
#var amount := 1

func bugtest():
	print('coords:',tile_coords," Item:",ITEM_DATA.ItemName)

func _init() -> void:
	tile_coords = Global.pos_to_grid(self.global_position)
	if is_gold:
		if ! dropped:
			stack_size = randi_range(1,10+DungeonData.AREA_LEVEL*2)
		if stack_size > (10+DungeonData.AREA_LEVEL*2) / 2:
			texture = load("res://Art/2D_images/gold_stack_large.png")
		else:
			texture = load("res://Art/2D_images/gold_stack_small.png")
		
	else:
		if ITEM_DATA.ItemName == 'Gold':
			ITEM_DATA = load("res://Resources/Items/Consumables/HealthPotion.tres")
		if ! dropped:
			stack_size = randi_range(1,floori(ITEM_DATA.max_stack/3.0))
		texture = ITEM_DATA.icon
		
	

func _ready() -> void:
	#print("data",ITEM_DATA,self.name)
	#set_label()
	await get_tree().create_timer(0.2).timeout
	set_label()
	pass

func set_label():
	stack_size = clampi(stack_size,1,ITEM_DATA.max_stack)
	#print(ITEM_DATA)
	if ITEM_DATA.max_stack > 1:
		$Label.visible = true
		$Label.text = str(stack_size)
		#print("stacksize: ",stack_size,"  label: ",$Label.text)
		#if amount > 1 and is_gold:
		#	$Label.text = str(amount)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			if is_gold:
				var gold_counter:GoldCounter = get_tree().get_first_node_in_group("Gold_Counter")
				PlayerStats.player_gold += stack_size
				gold_counter.increase_counter(stack_size)
				#print("stacksize: ",stack_size,"  label: ",$Label.text)
				queue_free()
			else:
				Add_to_Player_Inv()
				#body.ability_effect_calculations(load("res://Resources/Abilities/_basic_attacks/Healing_Potion.tres"),body)
				#queue_free()
				
		elif body.Team == body.Teams.ENEMY:
			if is_gold:
				body.held_gold += stack_size
				queue_free()
				return
			elif ITEM_DATA.ItemType == ITEM_DATA.ITEM_TYPE.TILE:
				PlayerStats.TileID_NamedInventory[ITEM_DATA.TILE_ID][1] += 1
				queue_free()
				return #THIS IS SUS AF, FIX THIS LATER
				
			
			match ITEM_DATA.GearType:
				ITEM_DATA.GEAR_TYPE.ARMOUR:
					if body.EQUIPMENT.equipped_armour != null:
						body.EQUIPMENT.Attempt_Equip_to_Unit(ITEM_DATA,0)
						body.drop_held_armour = true
				ITEM_DATA.GEAR_TYPE.WEAPON:
					if body.EQUIPMENT.equipped_weapon != null:
						body.EQUIPMENT.Attempt_Equip_to_Unit(ITEM_DATA,0)
						body.drop_held_weapon = true
				ITEM_DATA.GEAR_TYPE.TRINKET or ITEM_DATA.GEAR_TYPE.N_A:
					if body.EQUIPMENT.equipped_trinket != null:
						body.EQUIPMENT.Attempt_Equip_to_Unit(ITEM_DATA,0)
						body.drop_held_trinket = true



func Add_to_Player_Inv():
	print("attempt pick up ",ITEM_DATA.ItemName)
	var success_remainder = PlayerStats.Add_to_Player_Inv_stack(ITEM_DATA,stack_size)
	print("success/remainder",success_remainder)
	if success_remainder[1] > 0: #returns if anything went into inventory as a bool, and the 
		stack_size = success_remainder[1]#stack size of whatever didn't fit due to full inventory.
	else:
		queue_free()
	


func Attempt_Equip_to_Unit(unit:Unit_Instance):
	if unit.EQUIPMENT.Attempt_Equip_to_Unit(ITEM_DATA,0): #0 = GROUND in enum, 1 = INVENTORY
		stack_size -= 1 #^^^ RETURNS SUCCESS AS TRUE/FALSE
		if stack_size < 1:
			queue_free()
	pass

#func Attempt_Give_Unit_HoldItem(unit:Unit_Instance):
#	if unit.HeldItem == null:
#		unit.HeldItem = ITEM_DATA
#		unit.HeldItem_stacksize = stack_size
#		queue_free()
#	elif unit.HeldItem == ITEM_DATA:
#		var space = ITEM_DATA.max_stack-unit.HeldItem_stacksize
#		if space >= stack_size:
#			unit.HeldItem_stacksize+=stack_size
#			stack_size = 0
#			queue_free()
#		else:
#			unit.HeldItem_stacksize = ITEM_DATA.max_stack
#			stack_size -= space
#	else:
#		print("Already holding an Item.")
