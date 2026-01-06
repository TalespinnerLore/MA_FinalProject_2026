extends Node2D

@onready var TILE_ID = 0
enum RARITIES {BASIC,RARE,ELITE,UNIQUE}
@export var rarity:RARITIES
@export var slot_filled = false


func assign_tags():
	if rarity == RARITIES.BASIC:
		TILE_ID = 0
	elif rarity == RARITIES.RARE:
		TILE_ID = 1
	elif rarity == RARITIES.ELITE:
		TILE_ID = 2
	elif rarity == RARITIES.UNIQUE:
		TILE_ID = 3
	#$Sprite2D.frame = TILE_ID
	print(rarity," ",TILE_ID)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame = rarity
	#assign_tags()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
