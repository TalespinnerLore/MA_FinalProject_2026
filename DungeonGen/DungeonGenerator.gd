class_name Level_Generator
extends Node

@export var Height_Y = 30
@export var Width_X = 50

@export var Room_Attempts = 5
enum RoomSizes {RANDOM, CONSTRICTED, CLEARINGS, ALTERNATING}
enum RoomDensity {STANDARD, SPARSE, CRAMPED}
@export var Max_Size = 20
@export var Min_Size = 15
@export var Room_Sizes:RoomSizes
@export var Room_Density:RoomDensity
@export var Flooded:bool
@export var Lake:bool
@export var River_MaxAddedWidth = 2
@export var River_Tiles_list = []

@export var TileGrid = []
var Rooms = []
var Hallways = []

@export var AllRoomTiles = []
var AllWallTiles = []
var AllHallTiles = []
var UnusedTiles = []

func InGrid(x,y):
	if x < 1 or y < 1 or x >= Width_X-1 or y >= Height_Y-1:
		return false
	else:
		return true

func InitializeGrid():
	TileGrid.clear()
	for x in Width_X:
		TileGrid.append([])
		for y in Height_Y:
			TileGrid[x].append(1) #0 = FLOOR 1 = UNUSED, 2 = ROOM WALL, 3 = ERROR CHECKING, 4 = DOOR
			#print("Coord:",x,",",y)
			#print(TileGrid[x][y])

func RandomRooms(): #GENERATE RANDOM ROOMS ON THE GRID.
	for i in Room_Attempts:
		var startx = randi_range(1,Width_X-(2+Min_Size))
		var starty = randi_range(1,Height_Y-(2+Min_Size))
		var width = randi_range(Min_Size, Max_Size)
		var length = randi_range(Min_Size, Max_Size)
		if startx+width>=Width_X:
			width = (Width_X-1)-startx
		if starty+length>=Height_Y:
			length = (Height_Y-1)-starty
		
		if TileGrid[startx][starty] != 2 and TileGrid[startx+width][starty+length] != 2 and TileGrid[startx][starty+length] != 2 and TileGrid[startx+width][starty] != 2 \
		and TileGrid[startx][starty] != 0 and TileGrid[startx+width][starty+length] != 0 and TileGrid[startx][starty+length] != 0 and TileGrid[startx+width][starty] != 0\
		and TileGrid[startx+int(width/2)][starty] != 2 and TileGrid[startx+width][starty+int(length/2)] != 2 and TileGrid[startx][starty+int(length/2)] != 2 and TileGrid[startx+int(width/2)][starty+length] != 2 \
		and TileGrid[startx+int(width/2)][starty] != 0 and TileGrid[startx+width][starty+int(length/2)] != 0 and TileGrid[startx][starty+int(length/2)] != 0 and TileGrid[startx+int(width/2)][starty+length] != 0:
		#if the corners do not intersect with a present room, add it.
			var NewRoom = Rect2i(startx, starty, width, length)
			for x in range(NewRoom.position.x,NewRoom.end.x):
				for y in range(NewRoom.position.y,NewRoom.end.y):
					TileGrid[x][y] = 0
					AllRoomTiles.append(Vector2i(x,y))
					pass
			var RoomWalls = []
			for x in range(NewRoom.position.x-1,NewRoom.end.x+1):
				if x == NewRoom.position.x-1 or x == NewRoom.end.x:
					for y in range(NewRoom.position.y,NewRoom.end.y):
						TileGrid[x][y] = 2
						RoomWalls.append(Vector2i(x,y))
						AllWallTiles.append(Vector2i(x,y))
				else:
					RoomWalls.append(Vector2i(x,NewRoom.position.y-1))
					RoomWalls.append(Vector2i(x,NewRoom.end.y+1))
					AllWallTiles.append(Vector2i(x,NewRoom.position.y-1))
					AllWallTiles.append(Vector2i(x,NewRoom.end.y))
					TileGrid[x][NewRoom.position.y-1] = 2
					TileGrid[x][NewRoom.end.y] = 2
					
			Rooms.append([NewRoom, RoomWalls,[]])
	for room in Rooms:
		var filled = Roundify_Room(room[0])
		print(filled)
		for tile in filled:
			var cross = [[1,0],[-1,0],[0,1],[0,-1]]
			TileGrid[tile.x][tile.y] = 4
			for i in cross:
				room[1].erase(Vector2i(tile.x+i[0],tile.y+i[1]))
			AllRoomTiles.erase(Vector2i(tile.x,tile.y))
			AllWallTiles.append(Vector2i(tile.x,tile.y))
	pass


func Roundify_Room(room:Rect2i):
	var horizontal_fill = floori(room.size.x / 4)
	var vertical_fill = floori(room.size.y / 4)
	
	var bottom_corner =  room.position
	var top_corner = room.end-Vector2i(1,1)
	var x_corner = Vector2i(room.end.x-1,room.position.y)
	var y_corner = Vector2i(room.position.x,room.end.y-1)
	var to_fill = []#[bottom_corner,top_corner,x_corner,y_corner]
	var done = false
	while done == false:
		print("H: ",horizontal_fill,"   V: ",vertical_fill)
		for i in horizontal_fill:
			to_fill.erase(bottom_corner+Vector2i(i,0))
			to_fill.append(bottom_corner+Vector2i(i,0))
			to_fill.erase(top_corner+Vector2i(-i,0))
			to_fill.append(top_corner+Vector2i(-i,0))
			to_fill.erase(y_corner+Vector2i(i,0))
			to_fill.append(y_corner+Vector2i(i,0))
			to_fill.erase(x_corner+Vector2i(-i,0))
			to_fill.append(x_corner+Vector2i(-i,0))
		for i in vertical_fill:
			to_fill.erase(bottom_corner+Vector2i(0,i))
			to_fill.append(bottom_corner+Vector2i(0,i))
			to_fill.erase(top_corner+Vector2i(0,-i))
			to_fill.append(top_corner+Vector2i(0,-i))
			to_fill.erase(y_corner+Vector2i(0,-i))
			to_fill.append(y_corner+Vector2i(0,-i))
			to_fill.erase(x_corner+Vector2i(0,i))
			to_fill.append(x_corner+Vector2i(0,i))
		#done = true
		horizontal_fill -= 2
		clampi(horizontal_fill,0,999)
		vertical_fill -= 2
		clampi(vertical_fill,0,999)
		if horizontal_fill == 0 or vertical_fill == 0:
			done = true
		else:
			bottom_corner += Vector2i(1,1)
			top_corner += Vector2i(-1,-1)
			x_corner += Vector2i(-1,1)
			y_corner += Vector2i(1,-1)
		for i in horizontal_fill:
			to_fill.erase(bottom_corner+Vector2i(i,0))
			to_fill.append(bottom_corner+Vector2i(i,0))
			to_fill.erase(top_corner+Vector2i(-i,0))
			to_fill.append(top_corner+Vector2i(-i,0))
			to_fill.erase(y_corner+Vector2i(i,0))
			to_fill.append(y_corner+Vector2i(i,0))
			to_fill.erase(x_corner+Vector2i(-i,0))
			to_fill.append(x_corner+Vector2i(-i,0))
		for i in vertical_fill:
			to_fill.erase(bottom_corner+Vector2i(0,i))
			to_fill.append(bottom_corner+Vector2i(0,i))
			to_fill.erase(top_corner+Vector2i(0,-i))
			to_fill.append(top_corner+Vector2i(0,-i))
			to_fill.erase(y_corner+Vector2i(0,-i))
			to_fill.append(y_corner+Vector2i(0,-i))
			to_fill.erase(x_corner+Vector2i(0,i))
			to_fill.append(x_corner+Vector2i(0,i))
		done = true
	return to_fill
		#pass
		

var DeadEnds = []
var BridgeTiles = []
var toCheck = []


func Hallways_FloodFill(): #AFTER HAVING ROOMS, USE A FLOOD-FILL MAZE ALGORITHM TO FILL THE REMAINING SPACE.
	var current = UnusedTiles.pick_random() #Vector2i(1,1) #
	#print(current)
	toCheck.append(current)
	Hallways.append([])
	Hallways[-1].append(current)
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	
	while toCheck.size() > 0:
	#GET THE LAST TILE ON TO-CHECK, CHECK RANDOM ADJACENT TILES FO VALIDITY, IF FOUND: ADD TO LISTS.
	#IF NOT FOUND, POP LAST TILE FROM TO-CHECK. REPEAT UNTIL LIST IS EMPTY.
		
		dir.shuffle()
		current = Vector2i(toCheck.back())
		for i in 4:
			
			var bridgetile = current+dir[i]
			var floortile = current+(2*dir[i])

			if bridgetile.x < 1 or bridgetile.y < 1 or floortile.x < 1 or floortile.y < 1 \
			or bridgetile.x >= Width_X-1 or bridgetile.y >= Height_Y-1 or floortile.x >= Width_X-1 or floortile.y >= Height_Y-1:
				#print("OUT OF BOUNDS")
				if i == 3:
					DeadEnds.append([current, Hallways.size()-1])
					toCheck.pop_back()
					break
			else:
				if TileGrid[bridgetile.x][bridgetile.y] != 1 or TileGrid[floortile.x][floortile.y] != 1 \
				or Hallways[-1].has(bridgetile) or Hallways[-1].has(floortile)\
				or AllHallTiles.has(bridgetile) or AllHallTiles.has(floortile)\
				or AllHallTiles.has(floortile+Vector2i(1,0)) or AllHallTiles.has(floortile+Vector2i(-1,0))\
				or AllHallTiles.has(floortile+Vector2i(0,1)) or AllHallTiles.has(floortile+Vector2i(0,-1)):
					if i == 3:
						DeadEnds.append([current, Hallways.size()-1])
						toCheck.pop_back()
						break
				else:
					#print("currentTile: ",current)
					#print("B:",bridgetile," F:", floortile)
					toCheck.append(floortile)
					BridgeTiles.append(bridgetile)
					Hallways[-1].append(floortile)
					Hallways[-1].append(bridgetile)
					break
	for i in Hallways[-1]:
		TileGrid[i.x][i.y] = 0
		AllHallTiles.append(i)
	Hallways[-1].append([])
	FindUnusedTiles()
	pass

func FindUnusedTiles(): #FINDS ALL UNUSED TILES THAT COULD WORK AS A START POINT FOR A NEW SECTION OF HALLWAYS/MAZE.
	UnusedTiles.clear()
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),Vector2i(1,1), Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1)]
	for x in Width_X:
		for y in Height_Y:
			var valid = true
			for i in dir:
				if x+i.x < 1 or y+i.y < 1 or x+i.x >= Width_X-1 or y+i.y >= Height_Y-1:
					pass
				else:
					if TileGrid[x+i.x][y+i.y] == 0:
						valid = false
						break
			if valid == true and TileGrid[x][y] == 1 and x != 0 and x != (Width_X-1) and y != 0 and y != (Height_Y-1):
				UnusedTiles.append(Vector2i(x,y))
	pass

func ExtendDeadEnds(): #MAKES DEAD ENDS OF THE HALLWAYS TOUCH ROOMS AND CREATE POTENTIAL DOORWAY TILES.
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	var ToPop = []
	for i in DeadEnds:
		dir.shuffle()
		var count = FindNearbyFloorTiles(i[0].x,i[0].y)
		var tile = i[0]
		var hallnum = i[1]
		if count == 1:
			for xy in dir:
				var check1 = tile+xy
				var check2 = tile+(2*xy)
				if InGrid(check1.x,check1.y) == true and InGrid(check2.x,check2.y) == true:
					if TileGrid[check2.x][check2.y] == 2 and TileGrid[check1.x][check1.y] == 1:
						DeadEnds.append([check1, hallnum])
						TileGrid[check1.x][check1.y] = 0
						#print(Hallways[i])
						Hallways[hallnum].append(check1)
						ToPop.append(i)
						break
		else:
			ToPop.append(i)
	for bad in ToPop:
		DeadEnds.erase(bad)
	pass
	
func FillDeadEnds(max_ends):
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	#Find and pop all tiles registered as dead ends that are no longer dead ends.
	print("DeadEnds:",DeadEnds)
	var ToPop = []
	for check in DeadEnds:
		if FindNearbyFloorTiles(check[0].x, check[0].y) != 1:
			ToPop.append(check)
	for bad in ToPop:
		DeadEnds.erase(bad)
	print("DeadEnds no longer:",ToPop)

	
	DeadEnds.shuffle()
	var fgh = 0
	while DeadEnds.size() > max_ends: #fgh < 100:#
		fgh+=1
		#print(fgh)
		#print("DeadEnds:",DeadEnds)
		var coord = DeadEnds[-1][0]
		var hallnum = DeadEnds[-1][1]
		#print(coord, hallnum)
		for i in dir:
			var checking = coord+i
			#print(checking)
			if TileGrid[checking.x][checking.y] == 0: 
				#print("NearbyFloor: ",FindNearbyFloorTiles(checking.x, checking.y))
				if FindNearbyFloorTiles(checking.x, checking.y) == 2:
				#	print("NewEnd:",checking,"OldEnd:",coord)
					TileGrid[coord.x][coord.y] = 1# 1 #SWAP TO FIVE FOR ERROR CHECKING
				#	print("DeadEnds:",DeadEnds)
					DeadEnds.pop_back()
				#	print("DeadEnds:",DeadEnds)
					DeadEnds.append([checking, hallnum])
				#	print("DeadEnds:",DeadEnds)
					TileGrid[checking.x][checking.y] = 0
					break
				elif FindNearbyFloorTiles(checking.x, checking.y) > 2:
					TileGrid[coord.x][coord.y] = 1# 1 #SWAP TO FIVE FOR ERROR CHECKING
					DeadEnds.pop_back()
		if fgh > Height_Y*Width_X:
			break
	print("Post-Fill DeadEnds:", DeadEnds)
	pass
	

func FindNearbyEmptyTiles(x,y): #CHECKS FOR NUMBER OF ADJACENT EMPTY TILES.
	var count = 0
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	for i in dir:
		var check = i+Vector2i(x,y)
		if TileGrid[check.x][check.y] == 1:
			count+=1
	return count

func FindNearbyFloorTiles(x,y): #CHECKS FOR NUMBER OF ADJACENT FLOOR TILES.
	var count = 0
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	for i in dir:
		var check = i+Vector2i(x,y)
		if x <= Width_X-1 and y <= Height_Y -1:
			if TileGrid[check.x][check.y] == 0:# or TileGrid[check.x][check.y] == 4:
				count+=1
	return count

func FindNearbyWallTiles(x,y): #CHECKS FOR NUMBER OF ADJACENT FLOOR TILES.
	var count = 0
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),Vector2i(1,1), Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1)]
	for i in dir:
		var check = i+Vector2i(x,y)
		if x <= Width_X-1 and y <= Height_Y-1:
			if TileGrid[check.x][check.y] == 0:# or TileGrid[check.x][check.y] == 4:
				count+=1
	return count

func FindNearbyDoors(x,y): #CHECKS FOR NUMBER OF ADJACENT DOOR TILES.
	var count = 0
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),Vector2i(1,1), Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1)]
	for i in dir:
		var check = i+Vector2i(x,y)
		if PermDoors.has(check) or Extra.has(check):
			count+=1
	return count

var AllPossibleDoors = []
var FinalDoors = []
var LevelSections = []



func FindPossibleDoors(): #FINDS ALL ROOM WALL TILES THAT HAVE EXACTLY 2 FLOOR TILES ADJACENT, REGISTERS AS POSSIBLE DOOR.
						#THEN ADDS TILE TO LIST OF POSSIBLE DOORWAYS FOR EACH SECTION OF THE LEVEL (ROOMS/HALLWAYS).
	SectionSetup()
	for tile in AllWallTiles:
		var count = 0
		var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
		var neighbor_tiles = []
		for i in dir:
			var check = i+tile
			if 0<tile.x and tile.x<Width_X-1 and 0<tile.y and tile.y<Height_Y-1:
				if TileGrid[check.x][check.y] == 0 :#or TileGrid[check.x][check.y] == 4:
					count+=1
					neighbor_tiles.append(check)
		if count == 2:
			AllPossibleDoors.append(tile)
			var i = -1
			var j = 0
			for room in Rooms:
				i+=1
				#print(room[0])
				#print(room[1])
				if tile in room[1]:
					LevelSections[i][1].append(tile)
					Rooms[i][2].append(tile) #Rooms: [Rect2i, [List of Walls], [List of Possible Doors]]
					#print("ROOM: ",i)
			for hall in Hallways:
				j+=1
				#print(neighbor_tiles[0], neighbor_tiles[1])
				if hall.has(neighbor_tiles[0]) or hall.has(neighbor_tiles[1]) : 
					#LevelSections: [SectionNumber, [PossibleDoors]]
					LevelSections[i+j][1].append(tile)
					#print("HALL: ",j, " door tile: ", tile)
					#print(LevelSections[i+j][1])
			#TileGrid[tile.x][tile.y] = 4


func SectionSetup(): #Designates number of Sections the level is spearated into.
	LevelSections.clear()
	#var ToPop = []
	#for h in Hallways.size():
	#	if Hallways[h].size() < 2:
	#		ToPop.append(Hallways[h])
	#for h in ToPop:
	#	Hallways.erase(h)
	var i = -1
	for room in Rooms:
		i+=1
		LevelSections.append([i,[]])
		#add each room # and connection point to LevelSections
		pass
	for hall in Hallways:
		i+=1
		LevelSections.append([i,[]])
		#add each room # and connection point to LevelSections
		pass



func ConnectLevel_NEW(): #take each section of generated level, and connect them
	var Checklist = []
	var ToPop = []
	#append all doorways to a list.
	for sec in LevelSections:
		Checklist.append_array(sec[1])
	#sort the list
	Checklist.sort()
	#find each coordinate that dones not have a duplicate in the list, add to ToPop.
	for i in Checklist.size():
		if i != 0 and i != Checklist.size()-1:
			if Checklist[i] == Checklist[i-1] or Checklist[i] == Checklist[i+1]:
				pass
			else:
				ToPop.append(Checklist[i])
	#erase each coord from ToPop from the LevelSections
	for bad in ToPop:
		for sec in LevelSections:
			sec[1].erase(bad)
		
	while LevelSections.size() > 1:
		print("Connections number: ",LevelSections.size())
		var NEW = GlueSection(LevelSections)
		var ls = -1
		for LS in LevelSections:
			ls+=1
			print("Section ",ls,": ",LS)
			if LS[1].is_empty():
				LevelSections.pop_at(ls)
		print("Doors so far: ", PermDoors)
		LevelSections = NEW

	print("FinalDoors: ", PermDoors)
	for tile in PermDoors:
		#print("perm door tile: ", tile)
		TileGrid[tile.x][tile.y] = 0


func GlueSection(sections): #this glues the level sections together as one section
	var PossibleGlueDoors = []
	#print("Gluesec size:",sections.size())
	for i in range (1, sections.size()):
		for coord in sections[0][1]:
			if coord in sections[i][1]: 
			#if has matching coord
				
				var temp_section = sections[0][1] + sections[i][1]
				#print("temp sec:",temp_section)
				var new_section = []
				for j in temp_section:
					if j in sections[0][1] and j in sections[i][1]:
						PossibleGlueDoors.append(j)
						pass
					else:
						new_section.append(j)

				#add new doorway
				PermDoors.append(PossibleGlueDoors.pick_random())

				#create new array of sections
				var New_Sections = [[0,new_section]]
				for sec in sections:
					if sec != sections[0] and sec != sections[i]:
						New_Sections.append(sec)
				return New_Sections
	return sections

var PermDoors = []
var Extra = []
func ExtraDoors(): #makes extra doors to prevent perfection in the map

	for tile in AllWallTiles:
		#print("possible extra door:", tile)
		var count = 0
		
		if 0<tile.x and tile.x<Width_X-1 and 0<tile.y and tile.y<Height_Y-1 and FindNearbyFloorTiles(tile.x,tile.y) == 2\
		 and FinalDoors.has(tile) != true and FindNearbyDoors(tile.x,tile.y) < 1:
			
				if randi_range(1,100) <= 10:
					TileGrid[tile.x][tile.y] = 0
					Extra.append(tile)
	print("ExtraDoors: ",Extra)


func FillGrid(): #one the rooms are decided, this fills in the rest of the level
	FindUnusedTiles()
	while UnusedTiles.size() > 0:#for i in 3:#
		Hallways_FloodFill()
	ExtendDeadEnds()
	FindPossibleDoors()

@export var Items = []
@export var Objects = []
@export var spawnpoint = Vector2i(0,0)

func populate_floor(item_no):
	var stairs = AllRoomTiles.pick_random()
	Objects.append(['stairs',stairs])
	AllRoomTiles.erase(stairs)
	TileGrid[stairs.x][stairs.y] = 6
	spawnpoint = AllRoomTiles.pick_random()
	$BasicUnit.set_spawn(spawnpoint)
	
	AllRoomTiles.erase(spawnpoint)
	for item in item_no:
		var i = AllRoomTiles.pick_random()
		AllRoomTiles.erase(i)
		Items.append(i)



func generateRiver():
	var points = [] #all possble points for the river to start or end.
	var num_ends = randi_range(1,3)
	for x in Width_X:
		points.append([x,1])
	for y in Height_Y:
		points.append([1,y])
	points.shuffle() #get all border tiles, then shuffle the order.
	var river_start = points[0] #start point of river
	var river_end1 = points[1]
	
	var River_Tiles = []
	River_Tiles.append(river_start)
	River_Tiles.append(river_end1)
	var river_end2 = points[2]
	var river_end3 = points[3]
	if num_ends>1:
		River_Tiles.append(river_end2)
	if num_ends>2:
		River_Tiles.append(river_end3)
	#branching point chosen from the center section of the grid.
	#all distant points navigate to the brianching point, termitating if they find other river tiles.
	var branching_point = [randi_range(Width_X/4,Width_X-Width_X/4),randi_range(Height_Y/4,Height_Y-Height_Y/4)]
	River_Tiles.append(branching_point)

	var currentpoint = river_start
	var next_dir = [(branching_point[0]-currentpoint[0]).normalized(),(branching_point[1]-currentpoint[1]).normalized()]
	var nextpoint = currentpoint
	var riverwidth = randi_range(1,River_MaxAddedWidth)
	var prev_width = 1
	var prev_dir = [0,0]
	var expand_dir = [0,0]
	
	var go_diagonal = false
	for loop in num_ends+1:
		while currentpoint != branching_point:
			if currentpoint==river_start or currentpoint==river_end1 or currentpoint==river_end2 or currentpoint==river_end3:
				go_diagonal=false
			else:
				go_diagonal = randi_range(0,1)
			if next_dir[0]!=0 and next_dir[1]!=0:
				var xy = randi_range(1,2)
				if go_diagonal==false:
					if xy == 1:
						next_dir[1] = 0
					elif xy == 2:
						next_dir[0] = 0
					expand_dir = [1-next_dir[0],1-next_dir[1]]
				else:
					expand_dir = prev_dir
			#appends the next tile, and the two adjacent tiles in the opposite axis the river is advancing.
			nextpoint = [currentpoint[0]+next_dir[0],currentpoint[1]+next_dir[1]]
			River_Tiles.append(nextpoint)
			River_Tiles.append([currentpoint[0]+expand_dir[0],currentpoint[1]+expand_dir[1]])
			River_Tiles.append([currentpoint[0]-expand_dir[0],currentpoint[1]-expand_dir[1]])
			currentpoint = nextpoint
		currentpoint = River_Tiles[loop+1]
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	TileGrid.clear()
	InitializeGrid()
	RandomRooms()
	FillGrid()
	print("TotalSections: ",LevelSections.size(), ", Rooms: ", Rooms.size(), ", Hallways: ", Hallways.size())
	var ls = -1
	for LS in LevelSections:
		ls+=1
		print("Section ",ls,": ",LS)
	ConnectLevel_NEW()
	ExtraDoors()
	FillDeadEnds(6)
	populate_floor(6)
	#for i in UnusedTiles:
	#	TileGrid[i.x][i.y] = 3
	for i in DeadEnds:
		TileGrid[i[0].x][i[0].y] = 3
	for i in AllWallTiles: #replace wall tiles with generic red unused space.
		if TileGrid[i.x][i.y] == 2:
			TileGrid[i.x][i.y] = 1
	for i in Items:
		TileGrid[i.x][i.y] = 5
	$TileMapLayer.SetTiles(Width_X,Height_Y,TileGrid)
