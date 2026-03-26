class_name Unit_Group
extends Node2D

signal AbilityUsed(Ability:AbilityData,Source)
signal group_turn_completed
signal unit_defeated
signal on_turn_complete

#var current_unit: Unit_Instance
var current_unit_index = 0
var current_unit:Unit_Instance
@export var is_player_controlled = false
#turn order
#watch for team wipe (players)
#signal major events



func init() -> void:
	print("UNIT ",self.name," INITIALIZED")
	for child in get_children():
		child.init(is_player_controlled)#child.init(name, is_player_controlled)
		child.damaged.connect(_on_unit_damaged)
		child.unit_defeated.connect(_on_unit_defeated)
		
		if is_player_controlled:
			child.add_to_group("Player")
			#print(child," is player controlled")
			pass
		else:
			pass
	if get_children().size() > 0:
		current_unit = get_children()[0]
	#take_turn_team()

func temp_distribute():
	for unit in get_children():
		var validspawn = false
		var spawnpoint:Vector2i
		while validspawn == false:
			spawnpoint = $"../../TileMapLayer".cells_Ground.pick_random()
			if $"../../TileMapLayer".AllHallTiles.has(spawnpoint) or $"../../TileMapLayer".cells_Wall.has(spawnpoint):
				validspawn = false
			else:
				#print($"../../TileMapLayer".get_cell_tile_data(spawnpoint).terrain_set, "<- terrain ID, ",spawnpoint)
				unit.set_spawn(spawnpoint)
				#$"../../TileMapLayer".what_is_this_tile(spawnpoint.x,spawnpoint.y)
				validspawn = true


func take_turn_team() -> void:
	current_unit_index = -1
	for unit in get_active_units():
		unit.reset_turn()
	_step_turn()

func _step_turn() -> void:
	#await get_tree().create_timer(TURN_COOLDOWN).timeout
	if is_player_controlled:
		print('player turn')
		_step_turn_player()
	else:
		#print("ai turns not implemented yet")
		_step_turn_ai()
		pass



func _step_turn_player() -> void:
	print("stepped turn player")
	#check for end of turn
	
	var waiting_units = get_waiting_units()
	print(waiting_units)
	if waiting_units.size() <= 0:
		print("END player GROUP TURN")
		_end_group_turn()
		return
	disconnect_current_unit_signals()
#	current_unit = waiting_units[0]
	current_unit = waiting_units[0]
	waiting_units.pop_front()
	connect_current_unit_signals()
	current_unit._on_turn_start()
	#TAKE ACTIONS HERE
	

	
func _step_turn_ai() -> void:
	disconnect_current_unit_signals()
	#while true:
	current_unit_index+=1
	if current_unit_index >= get_child_count():
		print("END AI GROUPS TURN")
		_end_group_turn()
		return
	current_unit = get_child(current_unit_index)
#		if current_unit.can_take_turn == true:
			#break
	connect_current_unit_signals()
	current_unit._on_turn_start()
	#_step_unit()
	
func _on_unit_damaged() -> void:
	#camerashake here
	pass

func _on_unit_defeated():
	if get_active_units().size() == 0 and is_player_controlled == true:
		#defeated.emit(unit_defeated)
		pass
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
	#print(current_unit)
	current_unit.attack_start.connect(_process_ability)
	current_unit.turn_complete.connect(_step_unit)
	#print("connectted")
	pass

func disconnect_current_unit_signals() -> void:
	current_unit.attack_start.disconnect(_process_ability)
	current_unit.turn_complete.disconnect(_step_unit)
	pass

func _process_attack(ActionDef): #DEPRECIATED
	pass

func _process_ability(Ability:AbilityData,Source):#Ability,Source
	print("attack signal emitted ",Ability.ability_name,Source)
	emit_signal("AbilityUsed",Ability,Source)

func _step_unit():
	print('STEPPING UNIT NOW')
	disconnect_current_unit_signals()
	_step_turn()
	pass

func _end_group_turn():
	emit_signal("group_turn_completed")
	pass
