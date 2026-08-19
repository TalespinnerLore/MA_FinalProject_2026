extends Node2D
func _ready() -> void:
	var savekeys = SaveLoad.SaveFileData.checkpoint_persistance_keys
	if PlayerStats.p1_level > 4:
		savekeys['reached_level_5'] = true
		if PlayerStats.inventory_size < 15:
			PlayerStats.inventory_size = 15
		if PlayerStats.p1_level > 9:
			savekeys['reached_level_10'] = true
			if PlayerStats.inventory_size < 20:
				PlayerStats.inventory_size = 20
			if PlayerStats.p1_level > 14:
				savekeys['reached_level_15'] = true
				if PlayerStats.inventory_size < 30:
					PlayerStats.inventory_size = 30
				if PlayerStats.p1_level > 19:
					savekeys['reached_level_20'] = true
					if PlayerStats.inventory_size < 40:
						PlayerStats.inventory_size = 40
					if PlayerStats.p1_level > 24:
						savekeys['reached_level_25'] = true
						if PlayerStats.inventory_size < 50:
							PlayerStats.inventory_size = 50
	
	match PlayerStats.player_hub_location:
		0:
			$UnitNonCombat.position = Vector2(-400,1624)
		1:
			$UnitNonCombat.position = Vector2(-336,1624)
		2:
			$UnitNonCombat.position = Vector2(304,312)
		3:
			$UnitNonCombat.position = Vector2(304,1088)
		4:
			pass
		
	
