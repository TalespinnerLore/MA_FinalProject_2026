extends TextureRect

enum TEST{TEST1,TEST2}

func _ready() -> void:
	var test = TEST.keys()
	var biomedata:Biome = DungeonData.current_biome
	var bname = Biome.BIOMES.keys()[biomedata.BiomeID] 
	$LoadscreenLabel.text = str(bname,"\n","FLOOR ",DungeonData.current_floor,"/",DungeonData.max_floors)
	#ENUM_NAME.keys()[enum_val]
	
	await get_tree().create_timer(1.0).timeout
	self.visible = false
