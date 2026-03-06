class_name DungeonStairs
extends Sprite2D

signal player_found_stairs

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Unit_Instance:
		if body.Team == body.Teams.PLAYER:
			emit_signal("player_found_stairs")
			pass #SHOW DO YOU WANT TO GO TO THE NEXT FLOOR POPUP
	pass # Replace with function body.
