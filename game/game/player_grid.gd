extends Node2D

@onready var tile_map = $"../TileMap"
@onready var sprite = $Platform
@onready var raycast = $RayCast2D
var is_move = false
var direct = 1
@export var xp_max = 3

func _ready():
	#tile_map = Global.tile_map
	Xod.player_xp = xp_max

#func _ready():
	#Xod.player_pos = global_position

func _physics_process(delta):
	if Xod.player_xp <= 0:
		Xod.player_die = true
		#print(Xod.player_die)
		queue_free()
	if is_move == false:
		return
	if global_position == sprite.global_position:
		is_move = false
		return
	sprite.global_position = sprite.global_position.move_toward(global_position, 1)
	if sprite.global_position != global_position:
		return
	#await get_tree().create_timer(0.1).timeout
	Xod.xod_player = false
	#Xod.can_xod_player = false

func _flip():
	if direct == 1:
		$Platform/Player.flip_h = false
		$Platform/Player.position.x = 2
	else:
		$Platform/Player.flip_h = true
		$Platform/Player.position.x = -2

func _process(delta):
	if is_move == true:
		return
	if Xod.xod_player == false:
		return
	if Input.is_action_just_pressed("up"):
		_move(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		_move(Vector2.DOWN)
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
	var target_tile: Vector2i = Vector2i(current_tile.x + direction.x, current_tile.y + direction.y)
	#prints(current_tile, target_tile)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if tile_data.get_custom_data("walk") == true:
		raycast.target_position = direction * 16
		raycast.force_raycast_update()
		if raycast.is_colliding():
			$RayCast2D/player.global_position = $RayCast2D.global_position + direction * 16
			await get_tree().create_timer(0.1).timeout
			$RayCast2D/player.global_position = $RayCast2D.global_position
			await get_tree().create_timer(0.1).timeout
			Xod.xod_player = false
			#Xod.can_xod_player = false
			return
		is_move = true
		global_position = tile_map.map_to_local(target_tile)
		#Xod.player_pos = global_position
		sprite.global_position = tile_map.map_to_local(current_tile)
		#await get_tree().create_timer(0.1).timeout
		#Xod.xod_player = false
		
	#print(Xod.xod_player)
