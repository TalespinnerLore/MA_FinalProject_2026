class_name Dungeon_Floor
extends TileMapLayer

@export var Width_X = 70
@export var Height_Y = 40
@export var Max_Size = 15
@export var Min_Size = 5
@export var Room_Attempts = 25
@export var TileGrid = []
@export var Rooms = [] #Rect2i, FloorTiles, WallTiles
var Hallways = []
@export var Interconnectivity = 2 #0-10
var Max_Extra_Doorways = Rooms.size()*ceili(Interconnectivity/2.0) 
@export var Max_DeadEnds = 0 #in Interconnectivity is 5, max extra doors = 3*number of rooms
@export var Rounded = false

@export var SpawnRiver = false
@export var River_MaxAddedWidth = 3
@export var River_Tiles_list = []

@export var AllRoomTiles = []
var WallTiles = []
var AllHallTiles = []
var UnusedTiles = []

######TILEMAP CELLS######
var cells_Wall = []    ##
var cells_Ground = []  ##
var cells_Water = []   ##
#########################

func InitializeGrid():
	TileGrid.clear()
	for x in Width_X:
		TileGrid.append([])
		for y in Height_Y:
			TileGrid[x].append('WALL')

func InGrid(x,y):
	if x < 1 or y < 1 or x >= Width_X-1 or y >= Height_Y-1:
		return false
	else:
		return true

func FindNearbyFloorTiles(x,y): #CHECKS FOR NUMBER OF ADJACENT FLOOR TILES.
	var count = 0
	var dir = Global.dir4
	for i in dir:
		var check = i+Vector2i(x,y)
		if check.x <= Width_X-1 and check.y <= Height_Y-1:
			if TileGrid[check.x][check.y] == 'FLOOR':
				count+=1
	return count

func FindNearbyWallTiles(x,y): #CHECKS FOR NUMBER OF ADJACENT WALL TILES.
	var count = 0
	var dir =[Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),Vector2i(1,1), Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1)]
	for i in dir:
		var check = i+Vector2i(x,y)
		if x <= Width_X-1 and y <= Height_Y-1:
			if TileGrid[check.x][check.y] == 'ROOM_WALL':
				count+=1
	return count

func FindNearbyEmptyTiles(x,y): #CHECKS FOR NUMBER OF ADJACENT EMPTY TILES.
	var count = 0
	var dir = Global.dir4
	for i in dir:
		var check = i+Vector2i(x,y)
		if TileGrid[check.x][check.y] == 'WALL':
			count+=1
	return count

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
		
		if TileGrid[startx][starty] != 'ROOM_WALL' and TileGrid[startx+width][starty+length] != 'ROOM_WALL' and TileGrid[startx][starty+length] != 'ROOM_WALL' and TileGrid[startx+width][starty] != 'ROOM_WALL' \
		and TileGrid[startx][starty] != 'FLOOR' and TileGrid[startx+width][starty+length] != 'FLOOR' and TileGrid[startx][starty+length] != 'FLOOR' and TileGrid[startx+width][starty] != 'FLOOR'\
		and TileGrid[startx+int(width/2)][starty] != 'ROOM_WALL' and TileGrid[startx+width][starty+int(length/2)] != 'ROOM_WALL' and TileGrid[startx][starty+int(length/2)] != 'ROOM_WALL' and TileGrid[startx+int(width/2)][starty+length] != 'ROOM_WALL' \
		and TileGrid[startx+int(width/2)][starty] != 'FLOOR' and TileGrid[startx+width][starty+int(length/2)] != 'FLOOR' and TileGrid[startx][starty+int(length/2)] != 'FLOOR' and TileGrid[startx+int(width/2)][starty+length] != 'FLOOR':
		#if the corners do not intersect with a present room, add it.
			var NewRoom = Rect2i(startx, starty, width, length)
			for x in range(NewRoom.position.x,NewRoom.end.x):
				for y in range(NewRoom.position.y,NewRoom.end.y):
					TileGrid[x][y] = 'FLOOR'
					AllRoomTiles.append(Vector2i(x,y))
					pass
			var RoomWalls = []
			var RoomFloor = []
			for x in range(NewRoom.position.x-1,NewRoom.end.x+1):
				if x == NewRoom.position.x-1 or x == NewRoom.end.x:
					for y in range(NewRoom.position.y,NewRoom.end.y):
						TileGrid[x][y] = 'ROOM_WALL'
						RoomWalls.append(Vector2i(x,y))
				else:
					RoomWalls.append(Vector2i(x,NewRoom.position.y-1))
					RoomWalls.append(Vector2i(x,NewRoom.end.y))
					TileGrid[x][NewRoom.position.y-1] = 'ROOM_WALL'
					TileGrid[x][NewRoom.end.y] = 'ROOM_WALL'
			if Rounded == true:
				var new_walls = Roundify_Room(NewRoom)
				RoomWalls+=new_walls
			for x in range(NewRoom.position.x-1,NewRoom.end.x+1):
				for y in range(NewRoom.position.y-1,NewRoom.end.y+1):
					if TileGrid[x][y] == 'ROOM_WALL' and FindNearbyFloorTiles(x,y) < 1:
						TileGrid[x][y] = 'WALL'
						RoomWalls.erase(Vector2i(x,y))
					elif TileGrid[x][y] == 'FLOOR':
						RoomFloor.append(Vector2i(x,y))
			Rooms.append([NewRoom, RoomFloor, RoomWalls,[]])
				#[Rect2i, Vec2i Array, Vec2i Array, Doors?]
			#if Rounded != true and Rounded != false:
			#	Rounded = Global.randb()
	for x in Width_X:
		for y in Height_Y:
			if TileGrid[x][y] == 'ROOM_WALL' and FindNearbyFloorTiles(x,y) < 1:
				TileGrid[x][y] = 'WALL'
				AllRoomTiles.erase(Vector2i(x,y))
			elif TileGrid[x][y] == 'ROOM_WALL':
				AllRoomWalls.append(Vector2i(x,y))
				
	Max_Extra_Doorways = Rooms.size()*ceili(Interconnectivity/2.0) #just making sure this goes off
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
		if horizontal_fill <= 0 or vertical_fill <= 0:
			done = true
		else:
			bottom_corner += Vector2i(1,1)
			top_corner += Vector2i(-1,-1)
			x_corner += Vector2i(-1,1)
			y_corner += Vector2i(1,-1)
		for i in horizontal_fill: #to avoid duplicate issues. It's working, not touching it now.
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

	for tile in to_fill:
		TileGrid[tile.x][tile.y] = 'ROOM_WALL'
	return to_fill
		#pass
		
@export var DeadEnds = []
var BridgeTiles = []
var toCheck = []
var ERROR_CHECK_hallways = []

func Hallways_FloodFill(): #AFTER HAVING ROOMS, USE A FLOOD-FILL MAZE ALGORITHM TO FILL THE REMAINING SPACE.
	var current = UnusedTiles.pick_random() #Vector2i(1,1) #
	#print(current)
	toCheck.append(current)
	Hallways.append([])
	Hallways[-1].append(current)
	var dir = Global.dir4
	
	while toCheck.size() > 0:
	#GET THE LAST TILE ON TO-CHECK, CHECK RANDOM ADJACENT TILES FO VALIDITY, IF FOUND: ADD TO LISTS.
	#IF NOT FOUND, POP LAST TILE FROM TO-CHECK. REPEAT UNTIL LIST IS EMPTY.
		var WaterNum = 0
		var OtherBlocks = 0
		dir.shuffle()
		current = Vector2i(toCheck.back())
		for i in 4:
			
			var bridgetile = current+dir[i]
			var floortile = current+(2*dir[i])
			
			if bridgetile.x < 1 or bridgetile.y < 1 or floortile.x < 1 or floortile.y < 1 \
			or bridgetile.x >= Width_X-1 or bridgetile.y >= Height_Y-1 or floortile.x >= Width_X-1 or floortile.y >= Height_Y-1:
				#print("OUT OF BOUNDS")
				if i == 3:
					if Hallways[-1].size() == 1:
						if River_Tiles_list.has(current):
							TileGrid[current.x][current.y] = 'WATER'
							print("FOUND WATER DAMMIT")
						else:
							TileGrid[current.x][current.y] = 'ROOM_WALL'
						Hallways.pop_back()
					else:
						DeadEnds.append([current, Hallways.size()-1])
						toCheck.pop_back()
						break
			else:
				if TileGrid[bridgetile.x][bridgetile.y] != 'WALL' or TileGrid[floortile.x][floortile.y] != 'WALL' \
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
		TileGrid[i.x][i.y] = 'FLOOR'
		AllHallTiles.append(i)
	#Hallways[-1].append([])
	FindUnusedTiles()
	pass

func FindUnusedTiles(): #FINDS ALL UNUSED TILES THAT COULD WORK AS A START POINT FOR A NEW SECTION OF HALLWAYS/MAZE.
	UnusedTiles.clear()
	var dir = Global.dir8
	for x in Width_X:
		for y in Height_Y:
			var valid = true
			for i in dir:
				if x+i.x < 1 or y+i.y < 1 or x+i.x >= Width_X-1 or y+i.y >= Height_Y-1:
					pass
				else:
					if TileGrid[x+i.x][y+i.y] == 'FLOOR' or AllRoomTiles.has(Vector2i(x,y)+i):
						valid = false
						break
			if valid == true and TileGrid[x][y] == 'WALL' and x != 0 and x != (Width_X-1) and y != 0 and y != (Height_Y-1):
				UnusedTiles.append(Vector2i(x,y))
			#elif valid == true and TileGrid[x][y] == 'WATER' and x != 0 and x != (Width_X-1) and y != 0 and y != (Height_Y-1):
				# and AllRoomTiles.has(Vector2i(x,y)) == false:
				#UnusedTiles.append(Vector2i(x,y))
	pass

func ExtendDeadEnds(): #MAKES DEAD ENDS OF THE HALLWAYS TOUCH ROOMS AND CREATE POTENTIAL DOORWAY TILES.
	var dir = Global.dir4
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
					if TileGrid[check2.x][check2.y] == 'ROOM_WALL' and TileGrid[check1.x][check1.y] == 'WALL':
						DeadEnds.append([check1, hallnum])
						TileGrid[check1.x][check1.y] = 'FLOOR'
						Hallways[hallnum].append(check1)
						AllHallTiles.append(check1)
						ToPop.append(i)
						break
		else:
			ToPop.append(i)
	for bad in ToPop:
		DeadEnds.erase(bad)
	pass

func Simple_FillDeadEnds(max_ends):
	var ToPop = []
	for DE in DeadEnds:
		if FindNearbyFloorTiles(DE[0].x, DE[0].y) != 1:
			ToPop.append(DE)
	for bad in ToPop:
		DeadEnds.erase(bad)
	#print(DeadEnds)
	#this bit simply removes and erronous dead ends.
	
	var checklist = []
	for i in DeadEnds:
		checklist.append(i[0])
	
	while DeadEnds.size() > max_ends:
		DeadEnds.shuffle()
		var tile = DeadEnds[0][0]
		ToPop.append(DeadEnds[0])
		AllHallTiles.erase(tile)
		checklist.erase(tile)
		if River_Tiles_list.has(tile):
			TileGrid[tile.x][tile.y] = 'STAIRS'#'WATER'
		else:
			TileGrid[tile.x][tile.y] = 'WALL'#'WALL'
		
		for tile1 in AllHallTiles:
			if FindNearbyFloorTiles(tile1.x,tile1.y) == 1 and checklist.has(tile1) == false:
				DeadEnds.append([tile1,-999])
				checklist.append(tile1)
		for bad in ToPop:
			DeadEnds.erase(bad) 

func FillDeadEndHallway(tile):
	var ToFill = []
	var current_tile = tile
	var prev_tile = tile
	var is_DeadEnd = true
	ToFill.append(current_tile)
	while is_DeadEnd == true:
		print(current_tile," nearby floor: ",FindNearbyFloorTiles(current_tile.x, current_tile.y))
		if FindNearbyFloorTiles(current_tile.x, current_tile.y) < 3:
			for dir in Global.dir4:
				var check = current_tile+dir
				if TileGrid[check.x][check.y] == 'FLOOR' and check != prev_tile:
					prev_tile = current_tile
					current_tile = check
					print("Prevtile: ",prev_tile," dir: ",dir," Currenttile: ",current_tile)
					if FindNearbyFloorTiles(current_tile.x, current_tile.y) < 3:
						ToFill.append(current_tile)
		else:
			for tiles in ToFill:
				AllHallTiles.erase(tiles)
				if River_Tiles_list.has(tiles):
					TileGrid[tiles.x][tiles.y] = 'WATER'
				else:
					TileGrid[tiles.x][tiles.y] = 'WALL'
			is_DeadEnd = false
			break
	print("ToFill: ",ToFill)
	return(ToFill)
	

func FillDeadEnds(max_ends):
	#Find and pop all tiles registered as dead ends that are no longer dead ends.
	#print("DeadEnds:",DeadEnds)
	var dir = Global.dir4
	var ToPop = []
	for check in DeadEnds:
		if FindNearbyFloorTiles(check[0].x, check[0].y) != 1:
			ToPop.append(check)
	for bad in ToPop:
		DeadEnds.erase(bad)
	#print("DeadEnds no longer:",ToPop)
	DeadEnds.shuffle()
	var fgh = 0
	while DeadEnds.size() > max_ends:
		fgh+=1
		var coord = DeadEnds[-1][0]
		var hallnum = DeadEnds[-1][1]
		for i in dir:
			var checking = coord+i
			if TileGrid[checking.x][checking.y] == 'FLOOR': 
				if FindNearbyFloorTiles(checking.x, checking.y) == 2:
					TileGrid[coord.x][coord.y] = 'WALL'
					DeadEnds.pop_at(-1)
					DeadEnds.append([checking, hallnum])
					#TileGrid[checking.x][checking.y] = 'FLOOR'
					break
				elif FindNearbyFloorTiles(checking.x, checking.y) > 2:
					TileGrid[coord.x][coord.y] = 'WALL'
					DeadEnds.pop_at(-1)
		if fgh > Height_Y*Width_X:
			break #emergency break
	print("Post-Fill DeadEnds:", DeadEnds)
	pass

func FindNearbyDoors(x,y): #CHECKS FOR NUMBER OF ADJACENT DOOR TILES.
	var count = 0
	var dir = Global.dir8
	for i in dir:
		var check = i+Vector2i(x,y)
		if PermDoors.has(check) or Extra.has(check):
			count+=1
	return count

var AllPossibleDoors = []
var FinalDoors = []
var LevelSections = []
var PermDoors = []
var Extra = []
var AllRoomWalls = []


func SectionSetup(): #Designates number of Sections the level is spearated into.
	LevelSections.clear()
	var i = -1
	for room in Rooms:
		i+=1
		LevelSections.append([i,[]])
		#add each room index and connection points to LevelSections
		pass
	for hall in Hallways:
		i+=1
		LevelSections.append([i,[]])
		#add each room # and connection points to LevelSections
		pass

func FindPossibleDoors(): #FINDS ALL ROOM WALL TILES THAT HAVE EXACTLY 2 FLOOR TILES ADJACENT, REGISTERS AS POSSIBLE DOOR.
	SectionSetup() #THEN ADDS TILE TO LIST OF POSSIBLE DOORWAYS FOR EACH SECTION OF THE LEVEL (ROOMS/HALLWAYS).
	for tile in AllRoomWalls:
		var count = 0
		var dir = Global.dir4
		var neighbor_tiles = []
		for d in dir:
			var check = d+tile
			if 0<tile.x and tile.x<Width_X-1 and 0<tile.y and tile.y<Height_Y-1:
				if TileGrid[check.x][check.y] == 'FLOOR':
					count+=1
					neighbor_tiles.append(check)
		
		if count == 2:
			AllPossibleDoors.append(tile)
			var index = -1
			var jndex = 0
			for room in Rooms:
				index+=1
				if tile in room[2]:
					LevelSections[index][1].append(tile)
					Rooms[index][3].append(tile) #Rooms: [Rect2i, [Array Floor], [Array Walls], [List of Possible Doors]]
			for hall in Hallways:
				jndex+=1
				if hall.has(neighbor_tiles[0]) or hall.has(neighbor_tiles[1]) : 
					LevelSections[index+jndex][1].append(tile) #LevelSections: [SectionNumber, [PossibleDoors]]


func ConnectLevel_NEW(): #take each section of generated level, and connect them
	var Checklist = []
	var ToPop = []
	for sec in LevelSections: #append all doorways to a list.
		Checklist.append_array(sec[1])
	Checklist.sort() #sort the list
	#find each coordinate that does not have a duplicate in the list, add to ToPop.
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
		#print("Connections number: ",LevelSections.size())
		var NEW = GlueSection(LevelSections)
		var ls = -1
		for LS in LevelSections:
			ls+=1
			#print("Section ",ls,": ",LS)
			if LS[1].is_empty():
				LevelSections.pop_at(ls)
		#print("Doors so far: ", PermDoors)
		LevelSections = NEW
		
	#print("FinalDoors: ", PermDoors)
	for tile in PermDoors:
		TileGrid[tile.x][tile.y] = 'FLOOR'


func GlueSection(sections): #this glues the level sections together as one section
	var PossibleGlueDoors = []
	#print("Gluesec size:",sections.size())
	for i in range (1, sections.size()):
		for coord in sections[0][1]:
			if coord in sections[i][1]: #if has matching coord
				var temp_section = sections[0][1] + sections[i][1]
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

func ExtraDoors(): #makes extra doors to prevent perfection in the map
	for tile in AllRoomWalls:
		var count = 0
		if 0<tile.x and tile.x<Width_X-1 and 0<tile.y and tile.y<Height_Y-1 and FindNearbyFloorTiles(tile.x,tile.y) == 2\
		 and FinalDoors.has(tile) != true and FindNearbyDoors(tile.x,tile.y) < 1 and Max_Extra_Doorways > len(Extra):
				if randi_range(1,100) <= 10+floori(2.5*Interconnectivity):
					TileGrid[tile.x][tile.y] = 'FLOOR'
					Extra.append(tile)
	
	
	#print("ExtraDoors: ",Extra)


func generateRiver():
	var points = [] #all possble points for the river to start or end.
	var River_Tiles = []
	var expand_tiles = [] 
	var num_ends = randi_range(1,2)# down to 2 from 3, due to incidental swaztikas.
	for x in Width_X:
		points.append(Vector2i(x,0))
	for y in Height_Y:
		points.append(Vector2i(Width_X-1,y))
	for x in Width_X:
		points.append(Vector2i(Width_X-1-x,Height_Y-1))
	for y in Height_Y:
		points.append(Vector2i(0,Height_Y-1-y))
	#points.shuffle() #get all border tiles, then shuffle the order.
	
	var edgelen = (len(points)-1)
	var randstart = randi_range(1,edgelen)
	var river_start = points[randstart] #start point of river                  #print(randi_range((randstart-(1/(2*(num_ends+1))*edgelen)), (randstart-(3/(2*(num_ends+1))*edgelen))))
	River_Tiles.append(river_start)                                            #print("break") #print(randi_range((randstart-(3/(2*(num_ends+1))*edgelen)), (randstart-(5/(2*(num_ends+1))*edgelen))))
	var ed = [1,2,3] #for distributing river ends random quarters around the border.
	ed.shuffle() #so it's random, duh.
	var river_end1 = points[randstart-(edgelen*ed[0]/4 - randi_range(-1*ed[0]/8,ed[0]/8))]                             #points[randi_range((randstart-(1/(2*(num_ends+1))*edgelen)), (randstart-(3/(2*(num_ends+1))*edgelen)))]
	River_Tiles.append(river_end1)
	var river_end2 = points[randstart-(edgelen*ed[1]/4- randi_range(-1*ed[0]/8,ed[0]/8))]#points[randi_range((randstart-(3/(2*(num_ends+1))*edgelen)), (randstart-(5/(2*(num_ends+1))*edgelen)))]
	if num_ends>1:
		River_Tiles.append(river_end2)
	var river_end3 = points[randstart-(edgelen*ed[2]/4- randi_range(-1*ed[0]/8,ed[0]/8))]#[randi_range((randstart-(5/(2*(num_ends+1))*edgelen)), (randstart-(7/(2*(num_ends+1))*edgelen)))]
	if num_ends>2:
		River_Tiles.append(river_end3)
	
	#branching point chosen from the center section of the grid.
	#all distant points navigate to the brianching point, termitating if they find other river tiles.
	var branching_point = Vector2i(randi_range(Width_X/2,Width_X-Width_X/2),randi_range(Height_Y/2,Height_Y-Height_Y/2))
	River_Tiles.append(branching_point)
	for i in Global.dir4: #sets up the branching point as a cross so rivers don't 
		expand_tiles.append(branching_point+i)# look weird when coming into contact.
	var currentpoint = river_start
	var nextpoint = currentpoint
	
	var next_dir = Vector2i(clampi(branching_point.x-currentpoint.x,-1,1),clampi(branching_point.y-currentpoint.y,-1,1))
	var expand_dir = Vector2i(0,0)
	var default_dir = Vector2i(0,0)
	var go_diagonal = false 
	var test_tiles = []#river_start,river_end1,branching_point,river_end2] #]#
	var n = 0
	for river_branch in num_ends+1:
		currentpoint = River_Tiles[n] #next river branch start point.
		n+=1
		if currentpoint.x == 0:
			default_dir = Vector2i(0,1)
		elif currentpoint.x == Width_X-1:
			default_dir = Vector2i(0,-1)
		elif currentpoint.y == 0:
			default_dir = Vector2i(1,0)
		elif currentpoint.y == Height_Y-1:
			default_dir = Vector2i(-1,0)
		expand_dir = default_dir #sets the expand direction at the start of a river branch.
		
		var prev_width = 1
		var riverwidth = randi_range(1,River_MaxAddedWidth)
		for w in riverwidth:
			var w1 = Vector2i(currentpoint+(w+1)*expand_dir).clamp(Vector2i(0,0),Vector2i(Width_X-1,Height_Y-1)) 
			var w2 = Vector2i(currentpoint-(w+1)*expand_dir).clamp(Vector2i(0,0),Vector2i(Width_X-1,Height_Y-1))
			expand_tiles.append_array([w1,w2])
		for i in edgelen*num_ends: #abitrarily high limit to catch infinite loops, scaling with floor size.
			print("edgelen: ",edgelen)
			if next_dir.length() > 1: #IF NEXT DIRECTION IS DIAGONAL
				go_diagonal = Global.randb()
				if go_diagonal == false:
					var xy = randi_range(1,2) #move in X-axis, move in Y-axis.
					if xy == 1:
						next_dir.y = 0             #negate the move in the Y-axis.
						expand_dir = Vector2i(0,1) #expand the river in the Y-axis.
					elif xy == 2:
						next_dir.x = 0             #negate the move in the X-axis.
						expand_dir = Vector2i(1,0) #expand the river in the X-axis.
				elif go_diagonal == true:
					#expand the river in an axis based on the river's starting location.
					expand_dir = default_dir 
			else:
				expand_dir = Vector2i(1,1)-abs(next_dir)
				pass		
			#appends the next tile, and the two adjacent tiles in the opposite axis the river is advancing.
			nextpoint = Vector2i(currentpoint+next_dir).clamp(Vector2i(0,0),Vector2i(Width_X-1,Height_Y-1))
			River_Tiles.append(nextpoint)
			#River_Tiles.append(Vector2i(nextpoint+expand_dir).clamp(Vector2i.ZERO,Vector2i(Width_X-1,Height_Y-1)))
			#River_Tiles.append(Vector2i(nextpoint-expand_dir).clamp(Vector2i.ZERO,Vector2i(Width_X-1,Height_Y-1)))
			for w in riverwidth:
				expand_tiles.append(Vector2i(nextpoint+((w+1)*expand_dir)).clamp(Vector2i(0,0),Vector2i(Width_X-1,Height_Y-1))) #test_tiles
				expand_tiles.append(Vector2i(nextpoint-((w+1)*expand_dir)).clamp(Vector2i(0,0),Vector2i(Width_X-1,Height_Y-1)))
			#then set the new tile as the point for expansion, and calculate the next direction to advance.
			currentpoint = nextpoint
			next_dir = Vector2i(clampi(branching_point.x-currentpoint.x,-1,1),clampi(branching_point.y-currentpoint.y,-1,1))
			#next river width can be current width +-1, minimum 1, maximum River_MaxAddedWidth.
			prev_width = riverwidth
			riverwidth = clampi(randi_range(prev_width-1,prev_width+1),1,River_MaxAddedWidth)
			var checktile = currentpoint+next_dir
			checktile.clamp(Vector2i(0,0),Vector2i(Width_X-1,Height_Y-1))
			if River_Tiles.has(checktile) or TileGrid[checktile.x][checktile.y] == 'WATER': #is the next point already water?
				print("FOUND WATER")
				break #is water is found, break out of the loop for this river branch.
	
	River_Tiles.append_array(expand_tiles)
	River_Tiles_list.append_array(River_Tiles)
	for tile in River_Tiles:
		#push_error("ERROR - RiverIndex: ",River_Tiles.find(tile),", tile: ", tile)
		TileGrid[tile.x][tile.y] = 'WATER'
	print("endpoints: ",num_ends, ", end1 ",river_end1,", end2 ",river_end2,", end3 ",river_end3)
	#for tile in test_tiles:
	#	push_error("ERROR - testIndex: ",test_tiles.find(tile),\
	#				"tile: ", tile)
	#	TileGrid[tile.x][tile.y] = 'DOORWAY' #YELLOW IS EASY TO SEE
		#push_error("ERROR - testIndex: ",test_tiles.find(tile),", tile: ", tile)
	return [River_Tiles]#, test_tiles]





func FillGrid(): #once the rooms are decided, this fills in the rest of the level
	RandomRooms()
	FindUnusedTiles()
	
	while UnusedTiles.size() > 0:
		Hallways_FloodFill()
	ExtendDeadEnds()
	FindPossibleDoors()
	ConnectLevel_NEW()
	ExtraDoors()
		
	var rooms_missing_door = []
	var roomindex = -1
	for room in Rooms:
		roomindex +=1
		var hasdoor = false
		for tile in PermDoors:
			if room[2].has(tile):
				print("Room ",roomindex," door: ",tile)
				hasdoor = true
		if not hasdoor:
			rooms_missing_door.append(room)
			print("Room ",roomindex," has no door")
		else:
			print("room ",roomindex," has a door")
	print("missing doors num: ",rooms_missing_door.size())
	for room in rooms_missing_door:
		var intersect = []
		for door in AllPossibleDoors:
			if room[2].has(door):
				intersect.append(door)
		var emergency_door = intersect.pick_random()
		PermDoors.append(emergency_door)
		print(emergency_door,"<-emergencydoor")
		TileGrid[emergency_door.x][emergency_door.y] = 'FLOOR'
	
	#after all extra doors are made,
	for room in Rooms: #take every room,
		var toPop = []
		for possible_door in room[3]: #go through all the possible doors,
			if TileGrid[possible_door.x][possible_door.y] != 'FLOOR':
				toPop.append(possible_door) #find the unused doors in the list,
		for unused in toPop: #then erase them from the list, so I have a list of actual doors, connected to room data.
			room[3].erase(unused)
	
	#print(DeadEnds.size())
	Simple_FillDeadEnds(Max_DeadEnds)
	#print(DeadEnds.size())
	#print(DeadEnds)
	for i in DeadEnds:
		set_cell(Vector2i(i[0].x,i[0].y),0, Vector2i(0,2))
		
	##FillDeadEnds(Max_DeadEnds)
	#print(AllHallTiles.size(),"?")
	if SpawnRiver == true:
		generateRiver()
		for tile in AllHallTiles:
			if what_is_this_tile(tile.x,tile.y) == 'WATER':
				TileGrid[tile.x][tile.y] = 'FLOOR'
	
	
func place_stairs():
	var stairs = load("res://Objects/EnvironmentObjects/dungeon_stairs.tscn")
	pass
	
	######################
	#MAKE FLOOR NAVIGABLE#
	######################



func SetTiles(W,H,TG):
	#var TileGrid = self.get_parent().TileGrid
	#print("GridSize:", TileGrid.size())
	var count = 0
	for x in W:
		for y in H:
			#print("Coords: ",Vector2i(x,y)," Stored: ", TileGrid[x][y] )
			if TG[x][y] == 'FLOOR': #0, 'FLOOR'
				set_cell(Vector2i(x,y),0, Vector2i(0,0))
			elif TG[x][y] == 'ROOM_WALL': #2, 'ROOM_WALL'
				set_cell(Vector2i(x,y),0, Vector2i(1,0))
			elif TG[x][y] == 'UNUSED': #3, 'UNUSED'
				set_cell(Vector2i(x,y),0, Vector2i(0,1))
			elif TG[x][y] == 'DOORWAY': #4, 'DOORWAY'
				set_cell(Vector2i(x,y),0, Vector2i(0,2))
			elif TG[x][y] == 'ITEM' or TG[x][y] == 'WATER': #5, 'ITEM'/'WATER'
				set_cell(Vector2i(x,y),0, Vector2i(1,2))
				#count+=1
				#print("Coord: ", Vector2i(x,y)," ",TileGrid[x][y]," ",count)
			elif TG[x][y] == 'STAIRS': #6, 'STAIRS'
				set_cell(Vector2i(x,y),0, Vector2i(0,3))
			else: #1, 'WALL'
				set_cell(Vector2i(x,y),0, Vector2i(1,1))


func populate_tile_terrain():
	for x in Width_X:
		for y in Height_Y:
			if TileGrid[x][y] == 'WALL':
				set_cell(Vector2i(x,y),0, Vector2i(1,1))
				pass
			if TileGrid[x][y] == 'ROOM_WALL':
				set_cell(Vector2i(x,y),0, Vector2i(1,0))
				pass
			if TileGrid[x][y] == 'FLOOR':
				set_cell(Vector2i(x,y),0, Vector2i(0,0))
				#if River_Tiles_list.has(TileGrid[x][y]):
				#	print("sivubweivubsdvoin")
				#	set_cell(Vector2i(x,y),0, Vector2i(1,1))
				#	pass
				pass
			if River_Tiles_list.has(Vector2i(x,y)):
				set_cell(Vector2i(x,y),0, Vector2i(0,3))
				pass
			if TileGrid[x][y] == 'WATER':
				#set_cell(Vector2i(x,y),0, Vector2i(0,3))
				pass
			if TileGrid[x][y] == 'ROOM_WALL':
				cells_Wall.append(Vector2i(x,y))
			elif TileGrid[x][y] == 'WALL':
				if DungeonData.flooded:
					cells_Water.append(Vector2i(x,y))
				else:
					cells_Wall.append(Vector2i(x,y))
			elif TileGrid[x][y] == 'FLOOR':
				cells_Ground.append(Vector2i(x,y))
			elif TileGrid[x][y] == 'WATER' or River_Tiles_list.has(Vector2i(x,y)):
				cells_Water.append(Vector2i(x,y))
			for tile in DeadEnds:
				set_cell(Vector2i(tile[0].x,tile[0].y),0, Vector2i(0,2))
	if bugfixing != true:
		set_cells_terrain_connect(cells_Wall,terrain_set,0,true) #makes the auto-tiling work for generated stuff.
		set_cells_terrain_connect(cells_Ground,terrain_set,1,true)
		set_cells_terrain_connect(cells_Water,terrain_set,2,true)
		for tile in AllHallTiles:
			if River_Tiles_list.has(tile) or DungeonData.flooded:
				set_cell(Vector2i(tile.x,tile.y),terrain_set, Vector2i(10,10)) #THIS IS THE BRIDGE TILE
		
	pass




func what_is_this_tile(x,y):
	if River_Tiles_list.has(Vector2i(x,y)):
		print("isriver")
		pass
	if AllHallTiles.has(Vector2i(x,y)):
		print("ishallway")
		pass
	if DeadEnds.has(Vector2i(x,y)):
		print("isdedend")
		
	if TileGrid[x][y] == 'WALL':
		print("iswall")
		return('WALL')
		pass
	if TileGrid[x][y] == 'ROOM_WALL':
		print("isROOMWALL")
		return('ROOM_WALL')
		pass
	if TileGrid[x][y] == 'FLOOR':
		print("isfloor")
		return('FLOOR')
		pass
	if TileGrid[x][y] == 'WATER':
		print("iswater")
		return('WATER')
		pass

	pass
@export var bugfixing = false	
var terrain_set = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	terrain_set = DungeonData.floor_biome.BiomeID
	Max_Size = DungeonData.max_size
	Min_Size = DungeonData.min_size
	Room_Attempts = DungeonData.room_attempts
	Interconnectivity = DungeonData.interconnectivity
	Rounded = DungeonData.rounded
	SpawnRiver = DungeonData.spawn_river

	seed(randi())
	#seed(129)
	#print("BEGIN - SDIBRIVUN")
	InitializeGrid()
	FillGrid()
	#SetTiles(Width_X,Height_Y,TileGrid) #PLACES TESTINT TILESET, EASIER TO BUGFIX SOME THINGS.
	populate_tile_terrain()
	#for tile in FillDeadEndHallway(Vector2i(1,6)):
	#	set_cell(tile,0, Vector2i(0,3))
	#what_is_this_tile(1,19)
	#print("SDIBRIVUN - END")
	var validspawn = false
	var spawnpoint:Vector2i
	while validspawn == false:
		spawnpoint = cells_Ground.pick_random()
		if AllHallTiles.has(spawnpoint) or cells_Wall.has(spawnpoint):
			validspawn = false
		else:
			validspawn = true
	$"../Unit_Manager/Player_Group/Unit".set_spawn(spawnpoint)
	
	$"../Unit_Manager/Enemy_Group".temp_distribute()
	var i = -1
	for room in Rooms:
		i+=1
		print("room ",i," doors:",room[3])
	
			
			
	
	#print(Rooms[0][2])
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_ready()
