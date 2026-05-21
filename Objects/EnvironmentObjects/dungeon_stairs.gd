class_name DungeonStairs
extends Sprite2D

signal player_found_stairs
signal player_proceeding

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			emit_signal("player_found_stairs")
			$YesButton.visible = true
			$NoButton.visible = true
			$Proceed.visible = true

			pass #SHOW DO YOU WANT TO GO TO THE NEXT FLOOR POPUP
	pass # Replace with function body.

@onready var env_object_manager_ref:EnvironmentObjectManager = get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")


func init() -> void:
	if env_object_manager_ref != null:
		self.reparent(env_object_manager_ref)
		#env_object_manager_ref.unpassable_tiles.append(Global.pos_to_grid(self.global_position))
		#^^^unneeded, all units may walk over the stairs.


func _on_no_button_pressed() -> void:
	$YesButton.visible = false
	$NoButton.visible = false
	$Proceed.visible = false
	pass # Replace with function body.


func _on_yes_button_pressed() -> void:
	emit_signal("player_proceeding")
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			emit_signal("player_found_stairs")
			$YesButton.visible = false
			$NoButton.visible = false
			$Proceed.visible = false

	pass # Replace with function body.
