extends TileMapLayer



var cells_Ground = []

func SetTiles(W,H,TG):
	#var TileGrid = self.get_parent().TileGrid
	#print("GridSize:", TileGrid.size())
	for x in W:
		for y in H:
			#print("Coords: ",Vector2i(x,y)," Stored: ", TileGrid[x][y] )
			if TG[x][y] == 0:
				set_cell(Vector2i(x,y),0, Vector2i(0,0))
				cells_Ground.append(Vector2i(x,y))
			elif TG[x][y] == 2:
				set_cell(Vector2i(x,y),0, Vector2i(1,0))
			#elif x == 10 and y == 10:
			#	set_cell(Vector2i(x,y),0, Vector2i(0,1))#
			elif TG[x][y] == 3:
				set_cell(Vector2i(x,y),0, Vector2i(0,1))
			elif TG[x][y] == 4:
				set_cell(Vector2i(x,y),0, Vector2i(0,2))
			elif TG[x][y] == 5:
				set_cell(Vector2i(x,y),0, Vector2i(1,2))
			elif TG[x][y] == 6:
				set_cell(Vector2i(x,y),0, Vector2i(0,3))
			else:
				set_cell(Vector2i(x,y),0, Vector2i(1,1))


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
