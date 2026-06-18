extends Control
class_name AbilityUI

enum Pnum {P1,P2,P3,P4}
@export var PlayerUnit:Pnum
@export var connected_unit:Unit_Instance

func _ready() -> void:
	#self.visible = false
	#process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().create_timer(0.5).timeout
	load_data()
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Abilities"):
		open_close()


func open_close():
	self.visible = ! self.visible
	load_data()
	#pause_level()

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused


func load_data():
	match PlayerUnit:
		Pnum.P1:
			connected_unit = $"../../Unit_Manager/Player_Group".get_child(0) #1,2,3 for party member
			var index = 0
			print(PlayerStats.p1_equipped_abilities.size())
			print(PlayerStats.p1_ability_uses1234WAT.size())
			for box:UI_abilitybox in $Boxes.get_children():
				print("index: ",index)
				box.data = PlayerStats.p1_equipped_abilities[index]
				box.uses_remaining = PlayerStats.p1_ability_uses1234WAT[index]
				box.set_textures()
				index+=1
			
	pass

func _on_button_pressed() -> void:
	match PlayerUnit:
		Pnum.P1: # <<< probably dont need this match, remove later
			connected_unit.use_ability(0)
			var box:AbilityUI = $Button.get_child(0)
			box.uses_remaining = clampi(box.uses_remaining-1,0,999)
			box.set_textures()

func _on_button_2_pressed() -> void:
	match PlayerUnit:
		Pnum.P1:
			connected_unit.use_ability(1)
			var box:AbilityUI = $Button2.get_child(0)
			box.uses_remaining = clampi(box.uses_remaining-1,0,999)
			box.set_textures()
			
func _on_button_3_pressed() -> void:
	match PlayerUnit:
		Pnum.P1:
			connected_unit.use_ability(2)
			var box:AbilityUI = $Button3.get_child(0)
			box.uses_remaining = clampi(box.uses_remaining-1,0,999)
			box.set_textures()
			
func _on_button_4_pressed() -> void:
	match PlayerUnit:
		Pnum.P1:
			connected_unit.use_ability(3)
			var box:AbilityUI = $Button4.get_child(0)
			box.uses_remaining = clampi(box.uses_remaining-1,0,999)
			box.set_textures()
