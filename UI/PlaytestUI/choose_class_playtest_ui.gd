extends Control
@export var class_data:Array[StatComponent]
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
	await get_tree().create_timer(0.25).timeout
	#$"../../../TowerCraftingTile".interaction()
	queue_free()

func _on_button_pressed() -> void:
	print("Vanguard button pressed")
	PlayerStats.p1_class = class_data[0]
	PlayerStats.p1_equipped_abilities = v_abilities
	timeout()


func _on_button_pressed2() -> void:
	PlayerStats.p1_class = class_data[1]
	PlayerStats.p1_equipped_abilities = w_abilities
	timeout()


func _on_button_pressed3() -> void:
	PlayerStats.p1_class = class_data[2]
	PlayerStats.p1_equipped_abilities = r_abilities
	timeout()


func _on_button_pressed4() -> void:
	PlayerStats.p1_class = class_data[3]
	PlayerStats.p1_equipped_abilities = m_abilities
	timeout()


func _on_button_pressed5() -> void:
	PlayerStats.p1_class = class_data[4]
	PlayerStats.p1_equipped_abilities = h_abilities
	timeout()


func _on_button_pressed6() -> void:
	PlayerStats.p1_class = class_data[5]
	PlayerStats.p1_equipped_abilities = j_abilities
	timeout()
