extends Control
class_name  GoldCounter

var total:=0



func increase_counter(amount):
	total+=amount
	$TextureRect/Label.text = str(total,"\n","GOLD")

func _ready() -> void:
	#increase_counter(0)
	increase_counter(PlayerStats.player_gold)
	$floorlabel.text = str("Floor ",DungeonData.current_floor,"/",DungeonData.max_floors)
