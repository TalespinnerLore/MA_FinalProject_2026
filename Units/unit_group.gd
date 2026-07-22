class_name Unit_Group
extends Node2D

signal AbilityUsed(Ability:AbilityData,Source)
signal group_turn_completed
signal unit_defeated
signal on_turn_complete
signal dungeon_boss_defeated

#var current_unit: Unit_Instance
var current_unit_index = 0
var current_unit:Unit_Instance
@export var is_player_controlled = false
#turn order
#watch for team wipe (players)
#signal major events

var UnitManager:Unit_Manager
var player_dead = false


func init() -> void:
	UnitManager = self.get_parent()
	#print("UNIT ",self.name," INITIALIZED")
	for child in get_children():
		#print(child)
		init_child(child)
		UnitManager.Active_Units.append(child)
	if is_player_controlled:
		temp_distribute()
	
	if get_children().size() < DungeonData.max_wandering_units and ! is_player_controlled:
		for i in DungeonData.max_wandering_units/2:
			self.get_parent().spawn_unit(self)
	
	if get_children().size() > 0:
		current_unit = get_children()[0]
		connect_current_unit_signals()
	#take_turn_team()

func init_child(child):
	child.init(is_player_controlled)
	child.damaged.connect(_on_unit_damaged)
	child.unit_defeated.connect(_on_unit_defeated)
	#print(child.)
	
	if is_player_controlled:
		child.add_to_group("Player")
		pass
	else:
		pass

func temp_distribute():
	print("units to distribute: ",get_child_count())
	for unit:Unit_Instance in get_children():
		if is_player_controlled and DungeonData.current_floor == DungeonData.max_floors:
			unit.set_spawn(get_parent().tilemaplayer_ref.player_spawnpoint)
			#print("y no set player spawn? sp:",get_parent().tilemaplayer_ref.player_spawnpoint)
		else:
			var validspawn = false
			var spawnpoint:Vector2i
			while validspawn == false:
				spawnpoint = $"../../TileMapLayer".cells_Ground.pick_random()
				print("spawntile:",spawnpoint," loc:",Global.grid_to_pos(spawnpoint),$"../../TileMapLayer".what_is_this_tile(spawnpoint.x,spawnpoint.y))
				print("spawn in river?",$"../../TileMapLayer".River_Tiles_list.has(spawnpoint))
				print("spawn in wall?",$"../../TileMapLayer".WallTiles.has(spawnpoint))
				print("spawn terrain?",$"../../TileMapLayer".get_cell_tile_data(spawnpoint).terrain)
				print("spawntile:",Vector2i(10, 15)," loc:",Global.grid_to_pos(Vector2i(10, 15)),$"../../TileMapLayer".what_is_this_tile(Vector2i(10, 15).x,Vector2i(10, 15).y))
				print("spawn in river?",$"../../TileMapLayer".River_Tiles_list.has(Vector2i(10, 15)))
				print("spawn in wall?",$"../../TileMapLayer".WallTiles.has(Vector2i(10, 15)))
				print("spawn terrain?",$"../../TileMapLayer".get_cell_tile_data(Vector2i(10, 15)).terrain)
				if is_player_controlled:# and DungeonData.current_floor == DungeonData.max_floors:
					#print("isplayer, use spawnpoint")
					spawnpoint = get_parent().player_spawnpoint
					unit.set_spawn(spawnpoint)
					validspawn = true
					break
					#print("spawnpoint: ",spawnpoint)
					#print($"../../TileMapLayer".what_is_this_tile(spawnpoint.x,spawnpoint.y))
				if $"../../TileMapLayer".AllHallTiles.has(spawnpoint) or $"../../TileMapLayer".cells_Wall.has(spawnpoint):
					validspawn = false
					print("invalidspawn")
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
	if ! player_dead:
		#await get_tree().create_timer(TURN_COOLDOWN).timeout
		if is_player_controlled:
			#print('player turn')
			_step_turn_player()
		else:
			#print("ai turns not implemented yet")
			_step_turn_ai()
			pass



func _step_turn_player() -> void:
	#print("stepped turn player")
	#check for end of turn
	pass
	
	var waiting_units = get_waiting_units()
	#print(waiting_units)
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
	if current_unit_index > 0:
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

func _on_unit_defeated(xp_awarded):
	print("unit defeated triggering?")
	if get_active_units().size() == 1 and is_player_controlled == true:
		#defeated.emit(unit_defeated)
		pass
	#print("active enems: ",get_active_units().size()," is player? ",is_player_controlled,\
	#" is final? ",DungeonData.current_floor >= DungeonData.max_floors)
	
	if is_player_controlled == false:
		print("AWARDING XP TO PLAYER")
		for player_unit:Unit_Instance in get_parent().all_groups[0].get_children():
			print('playercheck - ',player_unit.UnitStats.UnitName)
			player_unit.give_XP(xp_awarded)
	#this goes off before the last unit is freed fom the queue, so 1 is correct.
	if get_active_units().size() == 1 and is_player_controlled != true \
	and DungeonData.current_floor >= DungeonData.max_floors:
		print("killed boss mob")
		emit_signal("dungeon_boss_defeated")
	elif is_player_controlled != true:
		print("unitgroup; defeated ",current_unit.UnitStats.UnitName)
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
	if is_instance_valid(current_unit):
		if current_unit.is_connected("attack_start",_process_ability):
			current_unit.attack_start.disconnect(_process_ability)
		if current_unit.is_connected("turn_complete",_step_unit):
			current_unit.turn_complete.disconnect(_step_unit)
	pass

func _process_attack(ActionDef): #DEPRECIATED
	pass

func _process_ability(Ability:AbilityData,Source):#Ability,Source
	#print("attack signal emitted ",Ability.ability_name,Source)
	emit_signal("AbilityUsed",Ability,Source)

func _step_unit():
	#print('STEPPING UNIT NOW')
	disconnect_current_unit_signals()
	_step_turn()
	pass

func _end_group_turn():
	emit_signal("group_turn_completed")
	pass
