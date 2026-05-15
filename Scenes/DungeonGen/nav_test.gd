extends Node2D
var NavManager_ref:NavigationManager = get_parent()

func _ready() -> void:
	pass
	NavManager_ref= get_parent()
	await get_tree().create_timer(3.5).timeout
	print("testpath ",NavManager_ref.get_valid_path_positions(Vector2i(5,5),Vector2i(7,5),0))
	print("testpathid ",NavManager_ref.get_valid_path_tiles(Vector2i(5,5),Vector2i(7,5),0))
