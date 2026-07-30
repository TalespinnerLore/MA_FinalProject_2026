extends VBoxContainer


enum STAT{STR,DEX,VIT,MAG,DEF,LUK,FREE}

@export var allocated_unsaved = [0,0,0,0,0,0]
@export var total = 0
@onready var top_charscreen_ui = get_parent().get_parent()
@onready var free_stat_label = $StatBox7/Label
#PlayerStats.p1_investedStrDexVitMagDefLuk[stat]

func show_hide_plusbtns(show:bool):
	for i in 6:
		var box:UIstatbox = get_child(i)
		box.get_child(3).visible = show

func show_hide_minusbtn(show:bool,index:int):
	var box:UIstatbox = get_child(index)
	box.get_child(2).visible = show

func _ready() -> void:
	for box:UIstatbox in get_children():
		box.increase_stat.connect(change_stat)#connect("increase_stat",change_stat(stat,true))
		box.decrease_stat.connect(change_stat)
		box.allocating_stats.connect(save_allocated_points)
		pass

func change_stat(stat:STAT,adding:bool):
	print("stat:",stat," adding? ",adding)
	var pointval = 1
	if ! adding:
		pointval = -1
	match top_charscreen_ui.PlayerUnit:
		top_charscreen_ui.Pnum.P1:
			if allocated_unsaved[stat] + pointval >= 0 and total + pointval <= PlayerStats.p1_free_stats:
				allocated_unsaved[stat] += pointval
				total+=pointval
				var numlabel = get_child(stat).get_child(1)
				numlabel.text = str(top_charscreen_ui.autostats[stat]\
				+PlayerStats.p1_investedStrDexVitMagDefLuk[stat]+allocated_unsaved[stat])
				free_stat_label.text = str("Free Stats - ",PlayerStats.p1_free_stats-total)
				if allocated_unsaved[stat] > 0:
					numlabel.set("theme_override_colors/font_color",Color.SPRING_GREEN)
					if total >= PlayerStats.p1_free_stats:
						show_hide_plusbtns(false)
					else:
						show_hide_plusbtns(true)
					show_hide_minusbtn(true,stat)
				else:
					numlabel.set("theme_override_colors/font_color",Color.BLACK)#(0.988,0.945,0.796)
					show_hide_minusbtn(false,stat)
			else:
				print("No removing saved points! tosave:",allocated_unsaved, "free:",PlayerStats.p1_free_stats)

func save_allocated_points(is_true:bool):
	if ! is_true:
		show_hide_plusbtns(false)
		for i in 6:
			show_hide_minusbtn(false,i)
		#print("SAVING STAT ALLOCATION, P1freestats:",PlayerStats.p1_free_stats)
		match top_charscreen_ui.PlayerUnit:
			top_charscreen_ui.Pnum.P1:
				for i in 6:
					PlayerStats.p1_investedStrDexVitMagDefLuk[i] += allocated_unsaved[i]
					#total+=allocated_unsaved[i]
					var numlabel = get_child(i).get_child(1)
					numlabel.set("theme_override_colors/font_color",Color.BLACK)
				PlayerStats.p1_free_stats -= total
				#print("P1freestats:",PlayerStats.p1_free_stats)
		if 'unit' in top_charscreen_ui:
			top_charscreen_ui.unit.set_stats()
		top_charscreen_ui.load_player_data()
	else:
		show_hide_plusbtns(true)
		allocated_unsaved = [0,0,0,0,0,0]
		total = 0
