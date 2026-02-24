extends Node2D

var hp:float = 2.0
@onready var maxhp:float = hp
@onready var parent = self.get_parent().get_parent()



func _take_damage(damage):
	print("HP: ",hp,)
	hp-=damage
	print("HP: ",hp)
	var barscale = clampf(hp/maxhp,0,maxhp)
	var fixedscale = round(barscale*32)/32.0
	print("BARSCALE: ",barscale)

	$Sprite2D.scale = Vector2(clampf(barscale, 0, maxhp), 1.0)
	
	$HP_Label.text = (str(hp)+"/"+str(maxhp))
	$HP_Outline.scale = Vector2(clampf(fixedscale, 0, maxhp), 1.0)
	$HP.scale = Vector2(clampf(barscale, 0, maxhp), 1.0)

	if hp<=0:
		if parent.has_method("_on_death"):
			parent._on_death()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
