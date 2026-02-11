class_name Unit_Group
extends Node2D

signal attack(ActionDef)
signal turn_completed
signal defeated
signal on_turn_complete

#var current_unit: Unit_Instance
var current_unit_index = 0
@export var is_player_controlled = false
#turn order
#watch for team wipe (players)
#signal major events



func init() -> void:
	print("UNIT group INITIALIZED")
	for child in get_children():
		child.init(is_player_controlled)#child.init(name, is_player_controlled)
		child.damaged.connect(_on_unit_damaged)
		child.unit_defeated.connect(_on_unit_defeated)
		
		if is_player_controlled:
			print(child," is player controlled")
			pass

func take_turn_team() -> void:
	current_unit_index = -1
	for unit in get_active_units():
		unit.reset_turn()
	_step_turn()

func _step_turn() -> void:
	#await get_tree().create_timer(TURN_COOLDOWN).timeout
	if is_player_controlled:
		_step_turn_player()
	else:
		#_step_turn_ai()
		pass



func _step_turn_player() -> void:
	#check for end of turn
	var waiting_units = get_waiting_units()
	if waiting_units.size() == 0:
		_end_turn()
		return
	disconnect_current_unit_signals()
#	current_unit = waiting_units[0]
	waiting_units.pop_front()
	connect_current_unit_signals()
	#TAKE ACTIONS HERE
	

	
func _step_turn_ai() -> void:
	disconnect_current_unit_signals()
	while true:
		current_unit_index+=1
		if current_unit_index >= get_child_count():
			_end_turn()
			return
#		current_unit = get_child(current_unit_index)
#		if current_unit.can_take_turn == true:
			break
	connect_current_unit_signals()
	_step_unit()
	
func _on_unit_damaged() -> void:
	#camerashake here
	pass

func _on_unit_defeated():
	if get_active_units().size() == 0 and is_player_controlled == true:
		defeated.emit()
	pass

func get_active_units():
	var active_units=[]#:Array[Unit_Instance] = []
	for child in get_children():
		if child.is_dead == false:
			active_units.append(child)
	return active_units

func get_waiting_units():
	var waiting_units=[]#: Array[Unit_Instance] = []
	for child in get_active_units():
		if child.has_taken_turn == false:
			waiting_units.append(child)
	return(waiting_units)


func connect_current_unit_signals() -> void:
	#current_unit.attack_complete.connect(_process_attack)
	pass

func disconnect_current_unit_signals() -> void:
	#current_unit.attack_complete.disconnect(_process_attack)
	pass

func _process_attack(ActionDef):
	pass

func _step_unit():
	pass

func _end_turn():
	pass
