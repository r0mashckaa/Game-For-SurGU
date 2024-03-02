extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var sprite = $Platform
@onready var raycast = $RayCast2D
var lable: bool = true
var lable_move: bool = true
var is_move = false
var direct = 1
var hit: bool
@export var xp_max = 3
var start_position
var anim_position
var shift_x
var shift_y
var veloc = global_position
@onready var mouse = get_global_mouse_position()

func _ready():
	#tile_map = Global.tile_map
	Global.player_xp = xp_max
	Global.xod_player = false
	start_position = sprite.global_position

#func _ready():
	#Xod.player_pos = global_position

func _label_move():
	if mouse != get_global_mouse_position() && Global.player_die == false:
		mouse = get_global_mouse_position()
		Global.label = true
	var mouse_x = get_global_mouse_position().x - global_position.x
	var mouse_y = get_global_mouse_position().y - global_position.y
	if tile_map.local_to_map(get_global_mouse_position()) == tile_map.local_to_map(global_position):
		$label.global_position = global_position
		veloc = Vector2.ZERO
	elif abs(mouse_x) > abs(mouse_y):
		#print(1)
		if mouse_x > 0:
			$label.global_position = Vector2(global_position.x + 16, global_position.y)
			veloc = Vector2.RIGHT
			#direct = 1
		elif mouse_x < 0:
			$label.global_position = Vector2(global_position.x - 16, global_position.y)
			veloc = Vector2.LEFT
			#direct = -1
	elif abs(mouse_x) < abs(mouse_y):
		#print(0)
		if mouse_y > 0:
			$label.global_position = Vector2(global_position.x, global_position.y + 16)
			veloc = Vector2.DOWN
		elif mouse_y < 0:
			$label.global_position = Vector2(global_position.x, global_position.y - 16)
			veloc = Vector2.UP
		#label_tile_data.get_custom_data("walk") == true

func _label():
	if lable_move == false:
		return
	if lable == true:
		lable_move = false
		$label/Label.position.y += 1
		lable = false
		await get_tree().create_timer(1).timeout
		lable_move = true
		return
	if lable == false:
		lable_move = false
		$label/Label.position.y -= 1
		lable = true
		await get_tree().create_timer(1).timeout
		lable_move = true
		return

func _physics_process(_delta):
	_label()
	#var label_tile_data: TileData = tile_map.get_cell_tile_data(0, veloc)
	_label_move()
	if Global.reset_player == true:
		Global.player_xp = xp_max
		#Global.reset_player = false
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
		global_position = Vector2(200, 104)
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
	if Input.is_action_just_pressed("click"):
		if veloc == Vector2.RIGHT:
			direct = 1
		elif veloc == Vector2.LEFT:
			direct = -1
		_move(veloc)
		Global.label = true
	elif Input.is_action_just_pressed("down"):
		_move(Vector2.DOWN)
		Global.label = false
	elif Input.is_action_just_pressed("up"):
		_move(Vector2.UP)
		Global.label = false
	elif Input.is_action_just_pressed("left"):
		_move(Vector2.LEFT)
		direct = -1
		Global.label = false
	elif Input.is_action_just_pressed("ridht"):
		_move(Vector2.RIGHT)
		direct = 1
		Global.label = false
	_flip()

func _move(direction: Vector2):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	#print(current_tile)
	var target_tile: Vector2 = Vector2(current_tile.x + direction.x, current_tile.y + direction.y)
	#prints(current_tile, target_tile)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if tile_data.get_custom_data("walk") == true:
		if Global.respawn == true:
			Global.set = true
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


func _on_press_area_entered(area):
	if area.name == "spikes":
		Global.player_xp -= 1
