extends VBoxContainer


enum STAT{STR,DEX,VIT,MAG,DEF,LUK,FREE}

@export var allocated_unsaved = [0,0,0,0,0,0]
@export var total = 0
@onready var top_charscreen_ui:UnitInventoryUI = get_parent().get_parent()
@onready var free_stat_label = $StatBox7/Label
#PlayerStats.p1_investedStrDexVitMagDefLuk[stat]

func show_hide_plusbtns(show:bool):
	for i in 6:
		var box:UIstatbox = get_child(i)
		box.get_child(3).visible = show

func show_hide_plusbtn(show:bool,index:int):
	var box:UIstatbox = get_child(index)
	box.get_child(2).visible = show

func _ready() -> void:
	for box:UIstatbox in get_children():
		box.increase_stat.connect(change_stat)#connect("increase_stat",change_stat(stat,true))
		box.decrease_stat.connect(change_stat)
		pass

func change_stat(stat:STAT,adding:bool):
	var pointval = 1
	if ! adding:
		pointval = -1
	match top_charscreen_ui.PlayerUnit:
		top_charscreen_ui.Pnum.P1:
			if allocated_unsaved[stat] + pointval > 0 and total + pointval <= PlayerStats.p1_free_stats:
				allocated_unsaved[stat] += pointval
				total+=pointval
				get_child(stat).get_child(1).text = PlayerStats.p1_investedStrDexVitMagDefLuk[stat]+allocated_unsaved[stat]
				free_stat_label.text = str("Free Stats - ",PlayerStats.p1_free_stats-total)
			else:
				print("No removing saved points!")

func save_allocated_points():
	match top_charscreen_ui.PlayerUnit:
		top_charscreen_ui.Pnum.P1:
			for i in 6:
				PlayerStats.p1_investedStrDexVitMagDefLuk[i] += allocated_unsaved[i]
				total+=allocated_unsaved[i]
			PlayerStats.p1_free_stats -= total
	
	top_charscreen_ui.load_data()
