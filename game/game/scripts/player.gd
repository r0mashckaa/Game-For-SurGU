extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var sprite = $player
@onready var raycast = $RayCast2D
var lable: bool = true
var lable_move: bool = true
var is_move = false
#var move = false
var direct = 1
var hit: bool
var can_xod = true
@export var xp_max = 3
@export var stan = false
@export var can_move = true
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

func _die():
	Global.player_die = true
	$"../../music".stop()
	$"../../die".play()
	$"../../die_icon".visible = true
	global_position = $"../../die_icon/AbilityIcon".global_position

func _physics_process(_delta):
	_label()
	#$Shadow.global_position = sprite.global_position
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
	if Global.player_xp <= 0 && Global.place == "game" && Global.player_die == false:
		_die()
		#print(Xod.player_die)
		#queue_free()
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
	await get_tree().create_timer(0.1).timeout
	can_xod = true
	Global.xod_player = false

func _flip():
	if direct == 1:
		$player/Platform/Player.flip_h = false
	else:
		$player/Platform/Player.flip_h = true

func _process(_delta):
	#print(can_xod)
	#print(is_move)
	#print(stan)
	if can_move == false:
		return
	if Global.bomba == true:
		return
	if Global.spawner == true:
		return
	if Global.player_xp > xp_max:
		Global.player_xp = xp_max
	if Global.player_die == true:
		return
	if Global.reset == true:
		return
	if is_move == true:
		return
	if Global.xod_player == false:
		Global.move = false
		hit = false
		return
	#if stan == true:
		#Global.xod_player = false
		#stan = false
		#return
	#$xod.stop()
	if Global.move == true: # can call bag
		return # can call bag
#	if hit == true:
#		return
#	can_xod = true
	if Input.is_action_just_pressed("click"):
		if veloc == Vector2.RIGHT:
			direct = 1
		elif veloc == Vector2.LEFT:
			direct = -1
		if veloc == Vector2.ZERO:
			return
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
	is_move = true
	if stan == true:
		Global.xod_player = false
		$RayCast2D/player/CollisionShape2D.disabled = true
		$slime.play("slime_stan")
		stan = false
		return
	else:
		$RayCast2D/player/CollisionShape2D.disabled = false
	Global.move = true # can call bag
	var current_tile: Vector2 = tile_map.local_to_map(global_position)
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
			$RayCast2D/player.global_position = raycast.global_position + direction * 16
			anim_position = Vector2(start_position * direction * 5)
			await get_tree().create_timer(0.1).timeout
			anim_position = Vector2(global_position)
			$RayCast2D/player.global_position = raycast.global_position
			await get_tree().create_timer(0.1).timeout
			if can_xod == true:
				Global.xod_player = false
			else: Global.move = false # can call bag
			#can_xod = true
			hit = false
			sprite.global_position = global_position
			return
		is_move = true
		if target_tile != current_tile:
			$AudioStreamPlayer.play()
		global_position = tile_map.map_to_local(target_tile)
		sprite.global_position = tile_map.map_to_local(current_tile)
		$xod.start()
		#await get_tree().create_timer(0.1).timeout
	else: Global.move = false # can call bag
	#print(Xod.xod_player)

func _on_press_area_entered(area):
	if area.name == "spikes"|| area.name == "barrel":
		if Global.shild == true:
			return
		Global.player_xp -= 1

func _on_player_area_exited(area):
	if area.name == "trap":
		Global.can_trap = true
	if area.name == "blok":
		#await get_tree().create_timer(0.2).timeout
		#can_xod = true
		pass

func _on_player_area_entered(area):
	if area.name == "block":
		can_xod = false
	elif area.name == "enviroment":
		can_xod = true
	elif area.name == "enemy":
		can_xod = true
	if area.name == "trap":
		Global.can_trap = false

func _on_timer_timeout():
	#print(1)
	Global.xod_player = true
	Global.move = false
