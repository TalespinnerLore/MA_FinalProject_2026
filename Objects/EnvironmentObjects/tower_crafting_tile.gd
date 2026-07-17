extends StaticBody2D


var towercrafting = load("res://Crafting/TowerCrafting_fixed.tscn")

func interaction():
	await get_tree().create_timer(0.25).timeout
	#$"../TowerCrafting".visible = true
	#$"../TowerCrafting".init()
	print("interacted with tower crafting tile")
	var craftui = towercrafting.instantiate()
	var player = get_tree().get_first_node_in_group("Player")
	player.visible = false
	player.global_position = Vector2(272,240-64)
	craftui.position = Vector2(-48,0)#272,144)
	get_parent().add_child(craftui)
	
func _ready() -> void:
	
	pass
	#interaction()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("activate crafting ui")
	interaction()
