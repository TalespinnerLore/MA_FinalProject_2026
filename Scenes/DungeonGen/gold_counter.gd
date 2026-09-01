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
	$TextureRectInv/Label.text = str(PlayerStats.player_inventory.size(),"/",\
									PlayerStats.inventory_size,"\n","INVENTORY")
	var biome = ''
	match DungeonData.floor_biome.BiomeID:
		0:
			biome = 'TEST BIOME'
		1:
			biome = 'Volcano'
		2:
			biome = 'Islands'
		3:
			biome = 'Mesa'
		4:
			biome = 'Skylands'
	var arealevel = str(DungeonData.AREA_LEVEL)
	$AreaInfo.text = str('BIOME: ',biome,'\nArea Level: ',arealevel)
	
