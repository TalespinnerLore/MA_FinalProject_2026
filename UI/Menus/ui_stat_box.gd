extends NinePatchRect
class_name UIstatbox

signal increase_stat(stat)
signal decrease_stat(stat)

enum STAT{STR,DEX,VIT,MAG,DEF,LUK,FREE}
@export var stat:STAT
