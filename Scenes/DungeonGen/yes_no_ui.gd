extends Control
class_name yes_no_UI

var stairs:DungeonStairs
var portal:HomePortal

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	swap_visibility()

func connect_stairs(object:DungeonStairs):
	object.player_found_stairs.connect(pause_level)
	stairs = object
	$Proceed.text = 'Proceed?'

func connect_portal(object:HomePortal):
	object.player_found_portal.connect(pause_level)
	portal = object
	$Proceed.text = 'Leave Dungeon?'


func pause_level():
	if is_instance_valid(get_tree()):
		await get_tree().create_timer(0.2).timeout
		get_tree().paused = true
	swap_visibility()
	pass

func swap_visibility():
	$YesButton.visible = ! $YesButton.visible
	$NoButton.visible = ! $NoButton.visible 
	$Proceed.visible = ! $Proceed.visible
	if $Proceed.visible:
		Input.MOUSE_MODE_VISIBLE
	else:
		Input.MOUSE_MODE_HIDDEN

func _on_no_button_pressed() -> void:
	get_tree().paused = false
	swap_visibility()
	pass # Replace with function body.

func _on_yes_button_pressed() -> void:
	get_tree().paused = false
	swap_visibility()
	if is_instance_valid(stairs):
		stairs.emit_signal("player_proceeding")
	elif is_instance_valid(portal):
		portal.emit_signal("player_proceeding")
	pass # Replace with function body.
