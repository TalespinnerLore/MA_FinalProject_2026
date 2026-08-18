extends Area2D

func open_door():
	$Sprite2D.texture = load("res://Art/UI_Art/EnvironmentSprites/towerdoor_open.png")
	$INVISWALL.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Unit_Instance_NonCombat:
		DungeonData.open_level_new()
	
