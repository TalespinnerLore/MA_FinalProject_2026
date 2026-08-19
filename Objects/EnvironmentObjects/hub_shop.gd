extends Node2D
class_name hub_shop

enum shopTYPE{POTIONS,GEAR,TILES,BANK,STRONGBOXES}
@export var shoptype:shopTYPE
var connectedui

func _ready() -> void:
	match shoptype:
		0:
			$Sprite2D.texture = load("res://Art/UI_Art/ui_icon_edible.png")
		1:
			$Sprite2D.texture = load("res://Art/UI_Art/ui_icon_armour.png")
		2:
			$Sprite2D.texture = load("res://Art/UI_Art/ui_blank.png")
		3:
			$Sprite2D.texture = load("res://Art/UI_Art/ui_icon_keyitem.png")
		4:
			$Sprite2D.texture = load("res://Art/UI_Art/ui_icon_lockbox.png")
			
func interaction():
	match shoptype:
		0:
			connectedui = get_tree().get_first_node_in_group('SHOP_UI_POTION')
			#connectedui.ShopType = 0
		1:
			connectedui = get_tree().get_first_node_in_group('SHOP_UI_GEAR')
			#connectedui.ShopType = 1
		2:
			connectedui = get_tree().get_first_node_in_group('SHOP_UI_TILES')
			#connectedui.ShopType = 2
		3:
			connectedui = get_tree().get_first_node_in_group('BANK_UI')
		4:
			connectedui = get_tree().get_first_node_in_group('STRONGBOXSHOP_UI')
	connectedui._player_interaction()
