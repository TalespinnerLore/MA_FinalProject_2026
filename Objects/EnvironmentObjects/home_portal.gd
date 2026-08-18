class_name HomePortal
extends Sprite2D

signal player_found_portal
signal player_proceeding

func enable_disable():
	$Area2D/CollisionShape2D.set_deferred("disabled", ! $Area2D/CollisionShape2D.disabled)
	visible = ! visible

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			emit_signal("player_found_portal")
			sfx_player.stream = load("res://Sounds/stage clear.ogg")
			sfx_player.play()

			pass #SHOW DO YOU WANT TO GO TO THE NEXT FLOOR POPUP
	pass # Replace with function body.

@onready var env_object_manager_ref:EnvironmentObjectManager = get_tree().get_first_node_in_group("ENVIRONMENT_OBJECT_MANAGER")
@onready var yn_UI:yes_no_UI = get_tree().get_first_node_in_group("Yes_No_UI")
@onready var sfx_player:AudioStreamPlayer = get_tree().get_first_node_in_group("SFX_PLAYER")


func init() -> void:
	yn_UI = get_tree().get_first_node_in_group("Yes_No_UI")
	yn_UI.connect_portal(self)
	if env_object_manager_ref != null:
		self.reparent(env_object_manager_ref)
		env_object_manager_ref.portal_ref = self
		#env_object_manager_ref.unpassable_tiles.append(Global.pos_to_grid(self.global_position))
		#^^^unneeded, all units may walk over the stairs.





#func _on_area_2d_body_exited(body: Node2D) -> void:
#	return #why does this function exist?
#	if body is Unit_Instance:
#		if body.Team == body.Teams.PLAYER:
#			emit_signal("player_found_portal")

	pass # Replace with function body.
