extends Control
class_name Main_Menu

@export var class_data:Array[StatComponent]
@export var c_abilities:Array[AbilityData]
@export var v_abilities:Array[AbilityData]
@export var w_abilities:Array[AbilityData]
@export var r_abilities:Array[AbilityData]
@export var m_abilities:Array[AbilityData]
@export var h_abilities:Array[AbilityData]
@export var j_abilities:Array[AbilityData]

func _ready() -> void:
	get_tree().paused = false

func timeout():
	print("triggered timeout")
	$"..".UnitStats = PlayerStats.p1_class
	$"..".init(true)
	await get_tree().create_timer(0.15).timeout
	_on_cont_button_pressed()
	#$"../../../TowerCraftingTile".interaction()
	queue_free()

func _on_button_pressed() -> void:
	print("Vanguard button pressed")
	PlayerStats.p1_class = class_data[0]
	PlayerStats.p1_equipped_abilities = v_abilities
	await get_tree().create_timer(0.15).timeout
	#open_to_house()
	open_to_crafting()



func _on_button_pressed2() -> void:
	PlayerStats.p1_class = class_data[1]
	PlayerStats.p1_equipped_abilities = w_abilities
	await get_tree().create_timer(0.15).timeout
	#open_to_house()
	open_to_crafting()



func _on_button_pressed3() -> void:
	PlayerStats.p1_class = class_data[2]
	PlayerStats.p1_equipped_abilities = r_abilities
	await get_tree().create_timer(0.15).timeout
	#open_to_house()
	open_to_crafting()



func _on_button_pressed4() -> void:
	PlayerStats.p1_class = class_data[3]
	PlayerStats.p1_equipped_abilities = m_abilities
	await get_tree().create_timer(0.15).timeout
	#open_to_house()
	open_to_crafting()



func _on_button_pressed5() -> void:
	PlayerStats.p1_class = class_data[4]
	PlayerStats.p1_equipped_abilities = h_abilities
	await get_tree().create_timer(0.15).timeout
	#open_to_house()
	open_to_crafting()



func _on_button_pressed6() -> void:
	PlayerStats.p1_class = class_data[5]
	PlayerStats.p1_equipped_abilities = j_abilities
	PlayerStats.p1_free_stats = 8
	await get_tree().create_timer(0.15).timeout
	#open_to_house()
	open_to_crafting()



func _on_new_button_pressed() -> void:
	SaveLoad._reset_save_file(1)
	SaveLoad._load(1)
	$OptionsBox.visible = false
	$ClassButtons.visible = true
	


func _on_cont_button_pressed() -> void:
	SaveLoad._load(1)
	SaveLoad.load_player_data()
	if SaveLoad.SaveFileData.is_in_dungeon:
		SaveLoad.load_dungeon_data()
		await get_tree().create_timer(0.2)
		#print('DUNDATA FIRE',DungeonData.Affinity_Fire)
		open_to_dungeon()
	elif SaveLoad.SaveFileData.is_in_hub:
		open_to_HUB()
	elif SaveLoad.SaveFileData.is_in_craftingroom:
		open_to_crafting()
	else:
		open_to_house()


func _on_dev_button_pressed() -> void:
	SaveLoad._load_devfile()
	SaveLoad.load_player_data()
	#open_to_house()
	#SaveLoad.load_dungeon_data()
	#await get_tree().create_timer(0.2)
	#print('DUNDATA FIRE',DungeonData.Affinity_Fire)
	#open_to_dungeon()
	open_to_house()

func _on_quit_button_pressed() -> void:
	get_tree().quit()


const HUBworld = "res://Scenes/StaticLevels/HubWorld.tscn"
const PLAYERhouse = "res://Scenes/StaticLevels/Player_House.tscn"
const CRAFTroom = "res://Scenes/StaticLevels/HubScene_Playtesting.tscn"


func open_to_house():
	get_tree().change_scene_to_file(PLAYERhouse)

func open_to_HUB():
	get_tree().change_scene_to_file(HUBworld)

func open_to_crafting():
	get_tree().change_scene_to_file(CRAFTroom)

func open_to_dungeon():
	DungeonData.current_floor -= 1 #the open level function automatically increments the floor by one.
	DungeonData.open_level_new()
	
