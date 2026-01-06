extends Resource
class_name Biome

enum BT{PLAINS,VOLCANO,ISLAND,CAVE}
enum ET{AIR,FIRE,WATER,EARTH}

@export var BiomeType: BT
@export var Element: ET
@export var Environmental_Features = []
@export var Unique_Rooms = []
@export var Common_Enemies = []
@export var Rare_Enemies = []
@export var Common_Items = ["$Moolah$"]
@export var Rare_Items = []
@export var Flooded:bool
