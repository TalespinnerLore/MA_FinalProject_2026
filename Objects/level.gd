class_name Level
extends Node

#VARIABLES CONTAIN DEFAULT BIOME INFO, ADDED MOBS, ADDED MOB TAGS, ADDED ITEMS.
#ON START - INITILIZES LEVEL GENERATOR
#WHEN COMPLETE, TELLS TILEMAP TO SET ACCORDING TO THE BIOME'S TILESET
#SPAWNS GROUND ITEMS, THE  SPAWNS INITIAL MOBS
#THEN PLACES THE PLAYER UNITS INTO THE LEVEL
#INITIALIZES THE SPAWNED UNITS, INITIALIZES THE PLAYER UNITS.

@export var level_needs_generation:bool = true
@onready var LevelGenerator: Level_Generator = $LevelGenerator
@onready var Tiles: TileMapLayer = $TileMap
@onready var Units: Unit_Manager = $Units
@onready var Items: Item_Manager = $Items
@onready var Objects: Object_Manager = $Objects

@export_category('GenerationVariables')
@export var FloorBiome: Biome
@export var Initial_EnemyDensity = 5
@export var Enemy_SpawnRate = 1.0
@export var isDungeon = true



func _ready() -> void:
	#if level_needs_generation:
	#	LevelGenerator.Generate_Level()
	
	#Units.reached_goal.connect(_on_reached_goal)
	#Units.player_died.connect(_on_player_died)
	
	Units.init()
	#Objects.init()
	#Items.init()
	#Units.start_gameplay()

func _on_reached_goal(found_stairs: bool) -> void:
	#spawn next floor here.
	pass

func _on_player_died(can_revive: bool) -> void:
	#show death screen here.
	pass
