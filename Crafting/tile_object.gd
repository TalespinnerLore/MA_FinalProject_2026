extends Node2D

var is_placed = false

var is_draggable = false
var is_inside_dropzone = false
var ref_dropzone
var cursor_offset:Vector2
var initial_pos:Vector2

@export var TILE_ID = 6
enum RARITIES {BASIC,RARE,ELITE,UNIQUE}
@export var rarity:RARITIES

@export var Crafting_Mods:Dictionary

func assign_tags():
	if TILE_ID < 18:#<32:
		rarity = RARITIES.BASIC
	elif TILE_ID < 42:#< 48:
		rarity = RARITIES.RARE
	elif TILE_ID < 45:#< 56:
		rarity = RARITIES.ELITE
	elif TILE_ID < 54:#< 64:
		rarity = RARITIES.UNIQUE
	else:
		rarity = 999 #null
	$Sprite2D.frame = TILE_ID
	Crafting_Mods = Tile_Crafting_Mods.values()[TILE_ID]
	
	#print(Crafting_Mods)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assign_tags()

func add_modifiers():
	if get_parent().has_method("change_modifiers"):
		print(Crafting_Mods.values()[1],Crafting_Mods.values()[2],Crafting_Mods.values()[3],Crafting_Mods.values()[4],Crafting_Mods.values()[5],true)
		get_parent().change_modifiers(Crafting_Mods.values()[1],Crafting_Mods.values()[2],Crafting_Mods.values()[3],Crafting_Mods.values()[4],Crafting_Mods.values()[5],true)

func remove_modifiers():
	if get_parent().has_method("change_modifiers"):
		get_parent().change_modifiers(Crafting_Mods.values()[1],Crafting_Mods.values()[2],Crafting_Mods.values()[3],Crafting_Mods.values()[4],Crafting_Mods.values()[5],false)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_draggable:
		if Input.is_action_just_pressed("Click"):
			initial_pos = self.global_position
			cursor_offset = get_global_mouse_position()-self.global_position
			Global.is_DraggingObject = true
		if Input.is_action_just_pressed("RightClick"):
			self.get_parent().adjust_count(TILE_ID,true)#what ID is it, and is it being added or removed?
			if ref_dropzone != null:
				ref_dropzone.slot_filled = false #set slot to empty
			remove_modifiers() #removes mdiefiers from the parent object
			queue_free() #remove tile object
			
		if Input.is_action_pressed("Click"): #While dragging, tile follows cursor.
			self.global_position = get_global_mouse_position()
			
		elif Input.is_action_just_released("Click"): #When dropped, either move back to initial location,
			Global.is_DraggingObject = false         # or into place in hovered slot.
			var tween = get_tree().create_tween()
			if is_inside_dropzone and "slot_filled" in ref_dropzone:
				print("TileRarity:",rarity," SlotRarity:",ref_dropzone.rarity," IsFilled?:",ref_dropzone.slot_filled)
				if not ref_dropzone.slot_filled and ref_dropzone.rarity >= rarity:
					tween.tween_property(self,"position",ref_dropzone.position,0.1).set_ease(tween.EASE_OUT)
					ref_dropzone.slot_filled = true
					is_placed = true
					add_modifiers() #add the modifiers to the towercrafting ui
					if taken_dropzone != null:
						taken_dropzone.slot_filled = false
					taken_dropzone = ref_dropzone
					_on_area_2d_mouse_exited()
					self.get_parent().adjust_count(TILE_ID,false)#what ID is it, and is it being added or removed?
				else:
					tween.tween_property(self,"position",initial_pos,0.1).set_ease(tween.EASE_OUT)
			else:
				tween.tween_property(self,"position",initial_pos,0.1).set_ease(tween.EASE_OUT)
			is_draggable = false #failsafe, in case of fuckery
	
	pass



func _on_area_2d_mouse_entered() -> void:
	#print("MOUSE ENTER")
	
	if not Global.is_DraggingObject:
		is_draggable = true
		#scale = Vector2(1.05,1.05)
		$ColorRect.visible = true



func _on_area_2d_mouse_exited() -> void:
	#print("MOUSE EXIT")
	if not Global.is_DraggingObject:
		is_draggable = false
		#scale = Vector2(1,1)
		$ColorRect.visible = false

var overlap_check = 0
var taken_dropzone

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("ENTERED - ",body.get_groups())
	overlap_check+=1
	if body.is_in_group("dropzone"):
		print("IS DROPZONE")
		is_inside_dropzone = true
		ref_dropzone = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("EXITED - ",body)
	overlap_check-=1
	if body.is_in_group("dropzone") and overlap_check==0:
		is_inside_dropzone = false
		ref_dropzone = null

var Tile_Crafting_Mods: Dictionary = {"TEST":
								{"ID": 0,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],0],[Global.DG_Mods["ELEMENTS"][1],0],[Global.DG_Mods["ELEMENTS"][2],0],[Global.DG_Mods["ELEMENTS"][3],0],[Global.DG_Mods["ELEMENTS"][4],0],[Global.DG_Mods["ELEMENTS"][5],0],[Global.DG_Mods["ELEMENTS"][6],0]],
								"environ":[[Global.DG_Mods["BIOMES"][0],0],[Global.DG_Mods["BIOMES"][1],0],[Global.DG_Mods["BIOMES"][2],0],[Global.DG_Mods["BIOMES"][3],0],[Global.DG_Mods["BIOMES"][4],0],\
										[Global.DG_Mods["ENV_FEATURES"][0],0],[Global.DG_Mods["ENV_FEATURES"][1],0],[Global.DG_Mods["ENV_FEATURES"][2],0],[Global.DG_Mods["ENV_FEATURES"][3],0],\
										[Global.DG_Mods["ROOMS"][0],0],[Global.DG_Mods["ROOMS"][1],0],[Global.DG_Mods["ROOMS"][2],0],[Global.DG_Mods["ROOMS"][3],0],[Global.DG_Mods["ROOMS"][4],0],[Global.DG_Mods["ROOMS"][5],0]],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],0],[Global.DG_Mods["MOB_MODIFIERS"][1],0],[Global.DG_Mods["MOB_MODIFIERS"][2],0],[Global.DG_Mods["MOB_MODIFIERS"][3],0],[Global.DG_Mods["MOB_MODIFIERS"][4],0],\
										[Global.DG_Mods["MOB_TYPE"][0],0],[Global.DG_Mods["MOB_TYPE"][1],0],[Global.DG_Mods["MOB_TYPE"][2],0],[Global.DG_Mods["MOB_TYPE"][3],0],[Global.DG_Mods["MOB_TYPE"][4],0],[Global.DG_Mods["MOB_TYPE"][5],0]],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],0],[Global.DG_Mods["ITEM_TYPE"][0],0],[Global.DG_Mods["ITEM_TYPE"][1],0],[Global.DG_Mods["ITEM_TYPE"][2],0],[Global.DG_Mods["ITEM_TYPE"][3],0],[Global.DG_Mods["ITEM_TYPE"][4],0],[Global.DG_Mods["ITEM_TYPE"][5],0],\
										[Global.DG_Mods["CLASS"][0],0],[Global.DG_Mods["CLASS"][1],0],[Global.DG_Mods["CLASS"][2],0],[Global.DG_Mods["CLASS"][3],0],[Global.DG_Mods["CLASS"][4],0],[Global.DG_Mods["CLASS"][5],0],\
										[Global.DG_Mods["GEAR_TYPE"][0],0],[Global.DG_Mods["GEAR_TYPE"][1],0],[Global.DG_Mods["GEAR_TYPE"][2],0]],
								"spec_feats":[[Global.DG_Mods["UNIQUE_ROOMS"][0],0],[Global.DG_Mods["UNIQUE_ROOMS"][0],0],\
									[Global.DG_Mods["BOSS"][0],0],[Global.DG_Mods["BOSS"][1],0],[Global.DG_Mods["BOSS"][2],0],[Global.DG_Mods["BOSS"][3],0],[Global.DG_Mods["BOSS"][4],0],[Global.DG_Mods["BOSS"][5],0],[Global.DG_Mods["BOSS"][6],0],[Global.DG_Mods["BOSS"][7],0],[Global.DG_Mods["BOSS"][8],0],[Global.DG_Mods["BOSS"][9],0],[Global.DG_Mods["BOSS"][10],0]]},
							"FIRE":
								{"ID": 1,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"WATER":
								{"ID": 2,
								"affinity":[[Global.DG_Mods["ELEMENTS"][1],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"EARTH":
								{"ID": 3,
								"affinity":[[Global.DG_Mods["ELEMENTS"][2],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"AIR":
								{"ID": 4,
								"affinity":[[Global.DG_Mods["ELEMENTS"][3],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"FORCE":
								{"ID": 5,
								"affinity":[[Global.DG_Mods["ELEMENTS"][4],1]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"VOLCANO":
								{"ID": 6,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],1]],
								"environ":[[Global.DG_Mods["BIOMES"][1],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"ISLANDS":
								{"ID": 7,
								"affinity":[[Global.DG_Mods["ELEMENTS"][1],1]],
								"environ":[[Global.DG_Mods["BIOMES"][2],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"MESA":
								{"ID": 8,
								"affinity":[[Global.DG_Mods["ELEMENTS"][2],1]],
								"environ":[[Global.DG_Mods["BIOMES"][3],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"SKY_ISLANDS":
								{"ID": 9,
								"affinity":[[Global.DG_Mods["ELEMENTS"][3],1]],
								"environ":[[Global.DG_Mods["BIOMES"][4],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"RIVER":
								{"ID": 10,
								"affinity":[],
								"environ":[[Global.DG_Mods["ENV_FEATURES"][0],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"LAKE":
								{"ID": 11,
								"affinity":[],
								"environ":[[Global.DG_Mods["ENV_FEATURES"][1],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"ROUND_ROOMS":
								{"ID": 12,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][0],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"DENSE_LAYOUT":
								{"ID": 13,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][1],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"SPARSE_LAYOUT":
								{"ID": 14,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][2],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"ALTERNATING_SIZE_ROOMS":
								{"ID": 15,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][3],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"SMALL_ROOMS":
								{"ID": 16,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][4],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"LARGE_ROOMS":
								{"ID": 17,
								"affinity":[],
								"environ":[[Global.DG_Mods["ROOMS"][5],1]],
								"mobs":[],
								"loot":[],
								"spec_feats":[]},
							"CONSUMABLES":
								{"ID": 18,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][2],1]],
								"spec_feats":[]},
							"GEAR":
								{"ID": 19,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][3],1]],
								"spec_feats":[]},
							"LOCKBOXES":
								{"ID": 20,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][3],1]],
								"spec_feats":[]},
							"WEAPONS":
								{"ID": 21,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["GEAR_TYPE"][0],1]],
								"spec_feats":[]},
							"ARMOUR":
								{"ID": 22,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["GEAR_TYPE"][1],1]],
								"spec_feats":[]},
							"TRINKETS":
								{"ID": 23,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["GEAR_TYPE"][2],1]],
								"spec_feats":[]},
							"VANGUARD":
								{"ID": 24,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][0],1]],
								"spec_feats":[]},
							"WARRIOR":
								{"ID": 25,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][1],1]],
								"spec_feats":[]},
							"MAGE":
								{"ID": 26,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][2],1]],
								"spec_feats":[]},
							"ROGUE":
								{"ID": 27,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][3],1]],
								"spec_feats":[]},
							"HEALER":
								{"ID": 28,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][4],1]],
								"spec_feats":[]},
							"JESTER":
								{"ID": 29,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["CLASS"][5],1]],
								"spec_feats":[]},
							"INCREASED_MOB_DENSITY":
								{"ID": 30,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],10],[Global.DG_Mods["MOB_MODIFIERS"][1],-1]],
								"loot":[],
								"spec_feats":[]},
							"INCREASED_GOLD":
								{"ID": 31,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_MODIFIERS"][3],1]],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][0],1]],
								"spec_feats":[]},
							"INCREASED_XP":
								{"ID": 32,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],-1],[Global.DG_Mods["MOB_MODIFIERS"][2],2]],
								"loot":[],
								"spec_feats":[]},
							"DECREASED_MOB_DENSITY":
								{"ID": 33,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],-10],[Global.DG_Mods["MOB_MODIFIERS"][1],3]],
								"loot":[],
								"spec_feats":[]},
							"DECREASED_GOLD":
								{"ID": 34,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_MODIFIERS"][3],-1],[Global.DG_Mods["MOB_MODIFIERS"][4],1]],
								"loot":[[Global.DG_Mods["ITEM_MODIFIERS"][0],1],[Global.DG_Mods["ITEM_TYPE"][0],-1],[Global.DG_Mods["ITEM_TYPE"][2],0.4],[Global.DG_Mods["ITEM_TYPE"][3],0.4]],
								"spec_feats":[]},
							"DECREASED_XP":
								{"ID": 35,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][2],-2],[Global.DG_Mods["MOB_MODIFIERS"][3],1],[Global.DG_Mods["MOB_MODIFIERS"][4],1]],
								"loot":[],
								"spec_feats":[]},
							"BEASTS":
								{"ID": 36,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][0],1]],
								"loot":[],
								"spec_feats":[]},
							"ELEMENTALS":
								{"ID": 37,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][1],1]],
								"loot":[],
								"spec_feats":[]},
							"UNDEAD":
								{"ID": 38,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][2],1]],
								"loot":[],
								"spec_feats":[]},
							"CONSTRUCTS":
								{"ID": 39,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][3],1]],
								"loot":[],
								"spec_feats":[]},
							"MORTALS":
								{"ID": 40,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][4],1]],
								"loot":[],
								"spec_feats":[]},
							"WILDLINGS":
								{"ID": 41,
								"affinity":[],
								"environ":[],
								"mobs":[[Global.DG_Mods["MOB_MODIFIERS"][0],1],[Global.DG_Mods["MOB_TYPE"][5],1]],
								"loot":[],
								"spec_feats":[]},
							"TREASURE_ROOM":
								{"ID": 42,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["UNIQUE_ROOMS"][0],1]]},
							"MINI_BOSS":
								{"ID": 43,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][1],1]]},
							"MONSTER_HOUSE":
								{"ID": 44,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["UNIQUE_ROOMS"][1],1]]},
							"T1_BOSS":
								{"ID": 45,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][2],1]]},
							"T1_FIREBOSS":
								{"ID": 46,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][3],1]]},
							"T1_WATERBOSS":
								{"ID": 47,
								"affinity":[[Global.DG_Mods["ELEMENTS"][1],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][4],1]]},
							"T1_EARTHBOSS":
								{"ID": 48,
								"affinity":[[Global.DG_Mods["ELEMENTS"][2],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][5],1]]},
							"T1_AIRBOSS":
								{"ID": 49,
								"affinity":[[Global.DG_Mods["ELEMENTS"][3],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][6],1]]},
							"T1_FORCEBOSS":
								{"ID": 50,
								"affinity":[[Global.DG_Mods["ELEMENTS"][4],2]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][7],1]]},
							"T2_BOSS":
								{"ID": 51,
								"affinity":[],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][8],1]]},
							"T2_QUADBOSS":
								{"ID": 52,
								"affinity":[[Global.DG_Mods["ELEMENTS"][0],1],[Global.DG_Mods["ELEMENTS"][1],1],[Global.DG_Mods["ELEMENTS"][2],1],[Global.DG_Mods["ELEMENTS"][3],1],],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][9],1]]},
							"T2_FORCEBOSS":
								{"ID": 53,
								"affinity":[[Global.DG_Mods["ELEMENTS"][4],4]],
								"environ":[],
								"mobs":[],
								"loot":[],
								"spec_feats":[[Global.DG_Mods["BOSS"][10],1]]},
							}
