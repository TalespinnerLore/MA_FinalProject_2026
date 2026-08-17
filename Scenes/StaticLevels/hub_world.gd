extends Node2D
func _ready() -> void:
	var savekeys = SaveLoad.SaveFileData.checkpoint_persistance_keys
	if PlayerStats.p1_level > 4:
		savekeys['reached_level_5'] = true
		if PlayerStats.p1_level > 9:
			savekeys['reached_level_10'] = true
			if PlayerStats.p1_level > 14:
				savekeys['reached_level_15'] = true
				if PlayerStats.p1_level > 19:
					savekeys['reached_level_20'] = true
					if PlayerStats.p1_level > 24:
						savekeys['reached_level_25'] = true
	
