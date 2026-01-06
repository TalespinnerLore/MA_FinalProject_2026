extends AnimatedSprite2D

signal turn_start
signal move_complete
signal attack_start(ActionDef)
signal attack_end(ActionDef)
signal unit_defeated
signal damaged
signal turn_complete

var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN,\
Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN+Vector2.LEFT]

@onready var ray = $RayCast2D
var tile_size = 32
var animation_speed = 3.0

var Team = "Player"

func move(dir,event):
	ray.target_position = directions[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",\
		position + directions[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		move_complete.emit()
	else:
		pass

var previous_tile = Vector2i(-1,-1)
var current_tile = Vector2i(-1,-1)
var target_tile = Vector2i(-1,-1)

var has_target = false

var Aggro = false
var Is_Player = false
var Is_NPC = false

func _turn_start():
	#check_player_visible()
	if has_target:
		var next_tile = target_direction_for_walk()
	else:
		var next_tile = random_look_for_walk()
	pass

func target_direction_for_walk():
	return [(current_tile+(target_tile-current_tile).normalized()),(target_tile-current_tile).normalized()]

func random_look_for_walk():
	var tiles_to_check = []
	for dir in directions:
		tiles_to_check.append(dir+current_tile)
	tiles_to_check.erase(previous_tile)
	if tiles_to_check.is_empty():
		return previous_tile
	return tiles_to_check.pick_random()
	
func move_to_tile(dir,teleport:bool):
	#remember to disbale collcicion for the move. !!!!!!!!!!!!
	var tween = create_tween()
	tween.tween_property(self, "position",\
	position + directions[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	move_complete.emit()
	turn_complete.emit()
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _swap_positions(unit):
	pass

func _attempt_pickup(item):
	pass


func movement_logic(dir_facing):
	ray.target_position = directions[dir_facing] * tile_size #rotate collision-checking ray to facing direction
	ray.force_raycast_update()
	var overlapping_body = ray.get_collider()
	if overlapping_body != false:
		var has_Team = Global.has_variable(overlapping_body, "Team")
		if has_Team:
			var unit_Team = Global.get_variable_value(overlapping_body, "Team")
			if Team == "Player" and unit_Team == "Player" or Team == "Player" and unit_Team =="NPC":
				_swap_positions(overlapping_body)
	else:
		move_to_tile(dir_facing, false)
