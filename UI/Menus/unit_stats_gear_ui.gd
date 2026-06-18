extends Control
class_name UnitInventoryUI

enum Pnum {P1,P2,P3,P4}
@export var PlayerUnit:Pnum

func load_data():
	match PlayerUnit:
		Pnum.P1:
			var classdata = PlayerStats.p1_class
			$gearInventoryBox/PortraitTextureRect.texture = classdata.Sprite
			$gearInventoryBox/WeaponTextureSlot/WeaponTexture.texture = PlayerStats.p1_weapon.icon
			$gearInventoryBox/ArmourTextureSlot/ArmourTexture.texture = PlayerStats.p1_armour.icon
			$gearInventoryBox/TrinketTextureSlot/TrinketTexture.texture = PlayerStats.p1_trinket.icon
			var index = 0
			for box in $StatAbilityBox/AbilityBoxContainer.get_children():
				box.data = PlayerStats.p1_equipped_abilities[index]
				box.uses_remaining = PlayerStats.p1_ability_uses1234WAT[index]
				box.set_textures()
				index+=1
			
	pass

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CharacterScreen"):
		open_close()


func open_close():
	if not visible:
		load_data()
	self.visible = ! self.visible
	pause_level()

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused
