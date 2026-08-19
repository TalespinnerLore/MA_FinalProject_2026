extends StaticBody2D


func interaction():
	swap_ui._player_interaction()

var swap_ui:UI_AbilitySelector

func _ready() -> void:
	swap_ui = get_tree().get_first_node_in_group('ABILITY_SWAP_UI')
	pass
	#interaction()
