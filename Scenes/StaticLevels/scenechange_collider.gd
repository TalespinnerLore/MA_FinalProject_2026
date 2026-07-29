extends Area2D
class_name scenechange_collider

@export var scene_to_open:String

func _on_body_entered(body: Node2D) -> void:
	if body is Unit_Instance_NonCombat:
		get_tree().change_scene_to_file(scene_to_open)
