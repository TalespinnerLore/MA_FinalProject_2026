extends StaticBody2D


var towercrafting = load("res://Crafting/TowerCrafting.tscn")

func interaction():
	await get_tree().create_timer(2).timeout
	$"../TowerCrafting".visible = true
	$"../TowerCrafting".init()
	print("interacted with tower crafting tile")
	#towercrafting.instantiate()
	#var player = get_tree().get_first_node_in_group("Player")
	#get_tree().root.add_child(towercrafting)

func _ready() -> void:
	pass
	#interaction()
