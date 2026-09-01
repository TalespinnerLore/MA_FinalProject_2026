class_name DungeonStairs
extends Sprite2D

signal player_found_stairs
signal player_proceeding

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		print('UNIT TOUCHED STAIRS: ',body.UnitStats.UnitName)
		if body.Team == body.Teams.PLAYER:
			emit_signal("player_found_stairs")

			pass #SHOW DO YOU WANT TO GO TO THE NEXT FLOOR POPUP
	pass # Replace with function body.

@onready var env_object_manager_ref:EnvironmentObjectManager = get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")
@onready var yn_UI:yes_no_UI = get_tree().get_first_node_in_group("Yes_No_UI")

func init() -> void:
	yn_UI = get_tree().get_first_node_in_group("Yes_No_UI")
	yn_UI.connect_stairs(self)
	if env_object_manager_ref != null:
		self.reparent(env_object_manager_ref)
		#env_object_manager_ref.unpassable_tiles.append(Global.pos_to_grid(self.global_position))
		#^^^unneeded, all units may walk over the stairs.





func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			emit_signal("player_found_stairs")

	pass # Replace with function body.
