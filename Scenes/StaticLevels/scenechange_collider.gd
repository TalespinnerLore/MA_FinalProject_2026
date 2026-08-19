extends Area2D
class_name scenechange_collider

enum HUB_LOC{SWAP_DOOR,SAVEPOINT_SWAP,TOWERDOOR,SAVEPOINT_MIDDLE}
@export var scene_to_open:String
@export var new_player_location:HUB_LOC

func _on_body_entered(body: Node2D) -> void:
	PlayerStats.player_hub_location = new_player_location
	if body is Unit_Instance_NonCombat:
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file(scene_to_open)
