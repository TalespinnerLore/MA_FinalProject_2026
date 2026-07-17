extends NinePatchRect
class_name UI_abilitybox

signal show_abilitydata(data)

@export var data:AbilityData
@export var uses_remaining:int
#enum ElementType {FIRE,WATER,EARTH,AIR,FORCE,LIGHT,DARK}
@export var elemUI = [preload("res://Art/UI_Art/ui_elem_fire.png"),preload("res://Art/UI_Art/ui_elem_water.png"),\
preload("res://Art/UI_Art/ui_elem_earth.png"),preload("res://Art/UI_Art/ui_elem_wind.png"),\
preload("res://Art/UI_Art/ui_elem_force.png"),preload("res://Art/UI_Art/ui_elem_light.png"),\
preload("res://Art/UI_Art/ui_elem_dark.png")]

@export var abilityUI = [preload("res://Art/UI_Art/AbilityType/ui_phys_generic.png"),\
preload("res://Art/UI_Art/AbilityType/ui_phys_melee.png"),preload("res://Art/UI_Art/AbilityType/ui_phys_ranged.png"),\
preload("res://Art/UI_Art/AbilityType/ui_mag_generic.png"),preload("res://Art/UI_Art/AbilityType/ui_mag_melee.png"),\
preload("res://Art/UI_Art/AbilityType/ui_mag_ranged.png"),preload("res://Art/UI_Art/AbilityType/ui_other_generic.png"),\
preload("res://Art/UI_Art/AbilityType/ui_other_shield.png"),preload("res://Art/UI_Art/AbilityType/ui_other_buff-debuff.png")]
#phys, physmelee,physranged,mag,magmelee,magranged,other
#fist,sword,bow,wand/ball0fmagic,glowing mace/fist?,staff, ? ,other = shield/up-arrow?

@export var aoeUI = [preload("res://Art/UI_Art/AoE/ui_aoe_front.png"),preload("res://Art/UI_Art/AoE/ui_aoe_line.png"),\
preload("res://Art/UI_Art/AoE/ui_aoe_cone.png"),preload("res://Art/UI_Art/AoE/ui_aoe_circle.png"),preload("res://Art/UI_Art/AoE/ui_aoe_self.png")]

func set_textures():
	print(data.ability_name)
	$elemTexture.texture = elemUI[data.element]
	if data.damage_type == data.DamageType.Other:
		if data.creates_shield:
			$abilityTexture.texture = abilityUI[7]
		else:
			$abilityTexture.texture = abilityUI[8]
	else:
		$abilityTexture.texture = abilityUI[data.damage_type]
	
	$aoeTexture.texture = aoeUI[data.targeting]
	$abilitynameLabel.text = data.ability_name
	#print("maxuses: ",data.max_uses)
	if data.max_uses < 999:
		$uselimitLabel.text = str("[",uses_remaining,"/",data.max_uses,"]")
	else:
		$uselimitLabel.text = '[INF]'
	pass


func _on_mouse_entered() -> void:
	#emit_signal("show_abilitydata",data)
	print("showing ability desc")
	get_tree().call_group("description", "ability_description",data)
