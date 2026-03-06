extends Node2D

var hp:float = 2.0
@onready var maxhp:float = hp
@onready var parent = self.get_parent().get_parent()
#fire,water,earth,air,force,light,dark
const element_hexcodes = ['ffffff','ffffff','d6cd97','ffffff','ffffff','ffffff','ffffff']

var shield_hp = 0.0
var shield_maxhp:float = 0.0
var shield_element = element_hexcodes[2]


func gain_shield(Ability:AbilityData,Source):
	shield_maxhp = Ability.base_value * Source.Def_Mult
	shield_hp = shield_maxhp
	shield_element = element_hexcodes[Ability.element]
	$Sprite2D_shield.self_modulate = shield_element
	var shieldscale = clampf(shield_hp/shield_maxhp,0,shield_maxhp)
	$Sprite2D_shield.scale = Vector2(clampf(shieldscale, 0, shield_maxhp), 1.0)
	$Sprite2D_shield.visible = true
	
func _take_damage(damage):
	if shield_hp > 0:
		shield_hp-=damage
		var shieldscale = clampf(shield_hp/shield_maxhp,0,shield_maxhp)
		$Sprite2D_shield.scale = Vector2(clampf(shieldscale, 0, shield_maxhp), 1.0)
		if shield_hp <= 0:
			$Sprite2D_shield.visible = false
			hp+=shield_hp
			var barscale = clampf(hp/maxhp,0,maxhp)
			$Sprite2D.scale = Vector2(clampf(barscale, 0, maxhp), 1.0)
	else:
		hp-=damage
		var barscale = clampf(hp/maxhp,0,maxhp)
		$Sprite2D.scale = Vector2(clampf(barscale, 0, maxhp), 1.0)

	#var fixedscale = round(barscale*32)/32.0
	#print("BARSCALE: ",barscale)
	#$HP_Label.text = (str(hp)+"/"+str(maxhp))
	#$HP_Outline.scale = Vector2(clampf(fixedscale, 0, maxhp), 1.0)
	#$HP.scale = Vector2(clampf(barscale, 0, maxhp), 1.0)

	if hp<=0:
		if parent.has_method("_on_death"):
			parent._on_death()
	return hp



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
