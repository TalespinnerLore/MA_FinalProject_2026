extends Node2D



var hp:float = 2.0
@onready var maxhp:float = hp
@onready var parent = self.get_parent().get_parent()
@onready var hp_bar = $NinePatchRect_HP
@onready var hp_bar_shield = $NinePatchRect_Shield
#fire,water,earth,air,force,light,dark
const element_hexcodes = ['ffffff','ffffff','d6cd97','ffffff','ffffff','ffffff','ffffff']

var shield_hp = 0.0
var shield_maxhp:float = 0.0
var shield_element = element_hexcodes[2]
var statuseeffects:Array[StatusEffectData]

func add_status_icon(Effect:StatusEffectData):
	if ! statuseeffects.has(Effect):
		statuseeffects.append(Effect)
		if statuseeffects.size()%3 != 0 and statuseeffects.size() > 0:
			var icon = TextureRect.new()
			icon.texture = Effect.icon
			$GridContainer_StatusEffects.add_child(icon)

func remove_status_icon(Effect:StatusEffectData):
	var index = statuseeffects.find(StatusEffectData)
	if index != -1:
		var topop = $GridContainer_StatusEffects.get_child(index)
		topop.queue_free()
		statuseeffects.pop_at(index)


func gain_shield(Ability:AbilityData,Source):
	$GridContainer_StatusEffects.position.y = -19
	shield_maxhp = Ability.base_value * Source.Def_Mult
	shield_hp = shield_maxhp
	shield_element = element_hexcodes[Ability.element]
	hp_bar_shield.self_modulate = shield_element
	var shieldscale = clampf(shield_hp/shield_maxhp,0,1)
	hp_bar_shield.size.x = clampf(shieldscale*32, 0, 32)
	hp_bar_shield.visible = true
	
func _take_damage(damage):
	if shield_hp > 0 and damage > 0:
		shield_hp-=damage
		var shieldscale = clampf(shield_hp/shield_maxhp,0,1)
		hp_bar_shield.size.x = clampf(shieldscale*32, 0, 32)
		if shield_hp <= 0:
			hp_bar_shield.visible = false
			$GridContainer_StatusEffects.position.y = -14
			hp+=shield_hp
			var barscale = clampf(hp/maxhp,0,1)
			hp_bar.size.x = clampf(barscale*32, 0, 32)
	else:
		hp-=damage
		var barscale = clampf(hp/maxhp,0,1)
		hp_bar.size.x = clampf(barscale*32, 0, 32)


	#var fixedscale = round(barscale*32)/32.0
	#print("BARSCALE: ",barscale)
	#$HP_Label.text = (str(hp)+"/"+str(maxhp))
	#$HP_Outline.scale = Vector2(clampf(fixedscale, 0, maxhp), 1.0)
	#$HP.scale = Vector2(clampf(barscale, 0, maxhp), 1.0)

	if hp<=0:
		hp_bar.visible = false
		if parent.has_method("_on_death"):
			parent._on_death()
	return hp



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
