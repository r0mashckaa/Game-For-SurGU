extends Node2D

@onready var tile_map = $"../TileMap"
@onready var sprite = $Platform
@onready var raycast = $RayCast2D
var is_move = false
var direct = 1
var hit: bool
var hit_end: bool
@export var xp_max = 3
var start_position
var anim_position
var shift_x
var shift_y

func _ready():
	#tile_map = Global.tile_map
	Global.player_xp = xp_max
	Global.xod_player = false
	start_position = sprite.global_position

#func _ready():
	#Xod.player_pos = global_position

func _physics_process(_delta):
	if Global.reset_player == true:
		Global.player_xp = xp_max
		Global.reset_player = false
		return
	if hit == true:
		#print(hit)
		sprite.global_position = sprite.global_position.move_toward(anim_position, 0.2)
		if sprite.global_position != anim_position:
			return
		shift_x = 0
		shift_y = 0
		hit = false
	if Global.player_xp <= 0 && Global.place == "game":
		Global.player_die = true
		#print(Xod.player_die)
		#queue_free()
		global_position = Vector2(184, 88)
		#Global.player_xp = xp_max
	if is_move == false:
		return
	if global_position == sprite.global_position:
		is_move = false
		return
	sprite.global_position = sprite.global_position.move_toward(global_position, 1)
	if sprite.global_position != global_position:
		return
	start_position = sprite.global_position
	hit_end = true
	#await get_tree().create_timer(0.1).timeout
	Global.xod_player = false

func _flip():
	if direct == 1:
		$Platform/Player.flip_h = false
	else:
		$Platform/Player.flip_h = true

func _process(_delta):
	if Global.player_xp > xp_max:
		Global.player_xp = xp_max
	if Global.player_die == true:
		return
	if Global.reset == true:
		return
	if is_move == true:
		return
	if Global.xod_player == false:
		hit = false
		return
	if Input.is_action_just_pressed("down"):
		_move(Vector2.DOWN)
	elif Input.is_action_just_pressed("up"):
		_move(Vector2.UP)
	elif Input.is_action_just_pressed("left"):
		_move(Vector2.LEFT)
		direct = -1
	elif Input.is_action_just_pressed("ridht"):
		_move(Vector2.RIGHT)
		direct = 1
	_flip()

func _move(direction: Vector2):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	#print(current_tile)
	var target_tile: Vector2 = Vector2(current_tile.x + direction.x, current_tile.y + direction.y)
	#prints(current_tile, target_tile)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if tile_data.get_custom_data("walk") == true:
		raycast.target_position = direction * 16
		raycast.force_raycast_update()
		if raycast.is_colliding():
			hit = true
			is_move = true
			$RayCast2D/player.global_position = $RayCast2D.global_position + direction * 16
			anim_position = Vector2(start_position * direction * 5)
			await get_tree().create_timer(0.1).timeout
			anim_position = Vector2(global_position)
			$RayCast2D/player.global_position = $RayCast2D.global_position
			await get_tree().create_timer(0.1).timeout
			hit = false
			sprite.global_position = global_position
			Global.xod_player = false
			return
		is_move = true
		global_position = tile_map.map_to_local(target_tile)
		sprite.global_position = tile_map.map_to_local(current_tile)
		#await get_tree().create_timer(0.1).timeout
		
	#print(Xod.xod_player)
