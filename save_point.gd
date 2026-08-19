extends StaticBody2D

func interaction():
	SaveLoad.save_current_playerdata()
	var hub_ref = get_tree().get_first_node_in_group('HUB_WORLD') 
	if hub_ref != null:
		SaveLoad.save_hub_data(get_tree().get_first_node_in_group('BANK_UI'))
	if DungeonData.current_floor > 1 or SaveLoad.SaveFileData.is_portal_open == true:
		SaveLoad.save_dungeon_data()
	SaveLoad._save(1)
