extends Control

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = ! get_tree().paused

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		_open_close()

func _open_close():
	pause_level()
	self.visible = ! self.visible
	



func _on_exilt_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/PlaytestUI/Main_Menu_UI.tscn")


func _on_close_button_pressed() -> void:
	_open_close()


func _on_back_button_pressed() -> void:
	$Recipes.visible = false
	pass # Replace with function body.


func _on_recipes_button_pressed() -> void:
	$Recipes.visible = true
	unlocked_pages = [0]
	var savekeys =  SaveLoad.SaveFileData.checkpoint_persistance_keys.duplicate(true)
	if savekeys['unlocked_recipe_monsterhouse']:
		unlocked_pages.append(1)
	if savekeys['unlocked_recipe_treasurevalut']:
		unlocked_pages.append(2)
	if savekeys['unlocked_recipe_miniboss']:
		unlocked_pages.append(3)
	if savekeys['unlocked_recipe_forceboss']:
		unlocked_pages.append(4)
	if savekeys['unlocked_recipe_fireboss']:
		unlocked_pages.append(5)
	if savekeys['unlocked_recipe_waterboss']:
		unlocked_pages.append(6)
	if savekeys['unlocked_recipe_earthboss']:
		unlocked_pages.append(7)
	if savekeys['unlocked_recipe_airboss']:
		unlocked_pages.append(8)
	if savekeys['unlocked_recipe_quadboss']:
		unlocked_pages.append(9)
	if savekeys['unlocked_recipe_forceboss2']:
		unlocked_pages.append(10)
	pass # Replace with function body.

var recipe_page = 1
var unlocked_pages = [0]

func _on_left_button_pressed() -> void:
	recipe_page = unlocked_pages[clampi(recipe_page-1,1,unlocked_pages.size()-1)]
	for i in range(1,11):
		$Recipes.get_child(i).visible = false
	$Recipes.get_child(recipe_page).visible = true
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	recipe_page = unlocked_pages[clampi(recipe_page+1,1,unlocked_pages.size()-1)]
	for i in range(1,11):
		$Recipes.get_child(i).visible = false
	$Recipes.get_child(recipe_page).visible = true
	pass # Replace with function body.
