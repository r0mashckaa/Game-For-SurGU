extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var player = $"../player"
@onready var player_sprite = $"../player/player"
@onready var sprite = $mob
var player_push = false
var astar_grid: AStarGrid2D
var is_move: bool
@export var stan: bool
var nomber
var move: bool
@export var die = true
var stage = 1 # 1-vampire, 2-bat...
@export var xp = 1
var room = 0
var shift = 1
var animca: bool
@export var spawner = false
@export var mob: String
var anim_position: Vector2
var start_position: Vector2
var dead_end
@export var cooldown = 6
@export var coin: PackedScene
@export var bonus: PackedScene
@export var call_mob: PackedScene
var is_spawn = false

func _ready():
	$mob.visible = false
	nomber = Global.nomber_mob
	Global.nomber_mob += 1
	Global.last_mob = nomber
	$Label.text = (str(nomber))
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(x + region_position.x, y + region_position.y)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			if tile_data == null or not tile_data.get_custom_data("walk"):
				astar_grid.set_point_solid(tile_position)
	await get_tree().create_timer(0.1).timeout
	$mob.visible = true
	if spawner == true:
		die = false
		xp = 1
		if mob == "skelet":
			if randi_range(1,2) == 1:
				stan = true
		#mob = "slime"
		nomber = 0
		#Global.quantity_mob += 1
		Global.nomber_mob -= 1
		Global.last_mob = Global.nomber_mob - 1
		#stan = true

func _range():
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	path.pop_front()
	if path.size() <= 4:
		return true
	else:
		return false

func _process(_delta):
	#if Global.hit == true:
		#return
	if Global.reset_player == true:
		stan = true
		return
	if die == true:
		if Global.spawn == true:
			#print("spawn")
			_spawn()
			return
		$AnimationPlayer.stop()
		return
	if is_move == true:
		return
	if Global.xod_player == true:
		move = false
		return
	if move == true:
		return
	$AnimationPlayer.stop()
	#if _range() == false:
		#Global.move_mob += 1
		#move = true
		#return
	if mob == "knight":
		_knight()
	elif mob == "golem":
		_golem()
	elif mob == "necromant":
		_necromant()
	elif mob == "ghost":
		_ghost()
	elif mob == "armor":
		if Global.quantity_mob == Global.quantity_armor:
			xp = -1
			Global.quantity_armor -= 1
			_die()
			return
		_armor()
	elif mob == "barrel":
		_barrel()
	elif mob == "slime":
		_slime()
	elif mob == "skelet":
		_skelet()
	elif mob == "vampire":
		_vampire()

func _tp():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var x = randi_range(1, Global.tile_max.x) * 16 + 8
	var y = randi_range(1, Global.tile_max.y) * 16 + 8
	var tp_tile: Vector2i = tile_map.local_to_map(Vector2(x, y))
	var data = tile_map.get_cell_tile_data(0, tp_tile)
	var tp: bool
	while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || tp == false:
		tp = true
		if tp_tile == tile_map.local_to_map(global_position):
			tp = false
		x = randi_range(1, Global.tile_max.x) * 16 + 8
		y = randi_range(1, Global.tile_max.y) * 16 + 8
		tp_tile = tile_map.local_to_map(Vector2(x, y))
		for enemy in enemies:
			if enemy == self:
				continue
			if tp_tile == tile_map.local_to_map(enemy.global_position):
				tp = false
		for decor in decors:
			if tp_tile == tile_map.local_to_map(decor.global_position):
				tp = false
		if data == null or not data.get_custom_data("walk"):
			tp = false
			continue
		#data = tile_map.get_cell_tile_data(0, tp_tile)
	$mob/Platform/mobs/Necromant.visible = false
	$tp.play()
	$teleport.emitting = true
	await get_tree().create_timer(0.1).timeout
	$mob/Platform/mobs/Necromant.visible = true
	global_position = Vector2(x, y)
	sprite.global_position = global_position
	start_position = sprite.global_position
	dead_end = true
	stan = true
	cooldown = 3

func _call():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var x = randi_range(-1, 1)# * 16 + 8
	var y = randi_range(-1, 1)# * 16 + 8
	var call_tile: Vector2i = Vector2i(tile_map.local_to_map(global_position).x + x, tile_map.local_to_map(global_position).y + y)
	var data = tile_map.get_cell_tile_data(0, call_tile)
	var calling: bool
	var time = 0
	while (call_tile == tile_map.local_to_map(player.global_position) || calling == false) && time <= 50:
		time += 1
		calling = true
		x = randi_range(-1, 1)
		y = randi_range(-1, 1)
		if x == 0 && y == 0:
			#calling = false
			if randi_range(1, 2) == 1:
				x += 1
			else:
				y += 1
			#continue
		#prints(x, y)
		call_tile = Vector2i(tile_map.local_to_map(global_position).x + x, tile_map.local_to_map(global_position).y + y)
		#print(call_tile)
		for enemy in enemies:
			if enemy == self:
				continue
			if call_tile == tile_map.local_to_map(enemy.global_position):
				calling = false
		for decor in decors:
			if call_tile == tile_map.local_to_map(decor.global_position):
				calling = false
		data = tile_map.get_cell_tile_data(0, call_tile)
		if data == null or not data.get_custom_data("walk"):
			calling = false
			continue
	#await get_tree().create_timer(0.1).timeout
	$spawn2.play()
	var temp_call_mob = call_mob.instantiate()
	$"..".add_child(temp_call_mob)
	temp_call_mob.mob = "skelet"
	temp_call_mob.spawner = true
	temp_call_mob.global_position = tile_map.map_to_local(call_tile)
	Global.move_mob += 1
	#Global.quantity_call_mob += 1
	#print(Global.call)
#	if Global.call == false:
#		Global.nomber_call_mob = 1
#		Global.call = true
#		Global.call_tile = call_tile
	#await get_tree().create_timer(0.4).timeout
	#$call.global_position = tile_map.map_to_local(call_tile)
	#sprite.global_position = global_position
	#start_position = sprite.global_position
	#prints(tile_map.local_to_map(global_position), tile_map.local_to_map(call_tile))


func _skelet():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac()
		stan = true
		return
	#else:
		#Global.move_mob += 1
		#move = true
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		move = true
		#if dead_end != false:
		return
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#print(global_position)
	sprite.global_position = original_position
	stan = true
	is_move = true

func _slime():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		#_atac()
		player.can_move = false
		player.stan = true
		var pos = global_position
		$enemy/CollisionShape2D.disabled = true
		global_position = player.global_position
		sprite.global_position = pos
		is_move = true
		Global.move_mob += 1
		move = true
		stan = true
		await get_tree().create_timer(0.2).timeout
		$"../player/player/Platform/Player/Slime".flip_h = $mob/Platform/mobs/Slime.flip_h
		$"../player/player/Platform/Player/Slime".visible = true
		xp = 0
		await get_tree().create_timer(0.1).timeout
		player.can_move = true
		return
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		room += 1
		move = true
		if dead_end == false:
			return
		if room >= 2:
			_die()
		return
	dead_end = false
	room = 0
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	$AnimationPlayer.play("move")
	#print(global_position)
	sprite.global_position = original_position
	is_move = true

func _necromant():
	if stan == true:
		cooldown -= 1
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		move = true
		if cooldown > 0:
			return
		stan = false
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		room += 1
		move = true
		if dead_end == false:
			return
		if room >= 2:
			_tp()
			room = 0
			return
	else:
		dead_end = false
		#Global.move_mob += 1
		move = true
		if stan == true:
			return
		await get_tree().create_timer(0.1).timeout
		stan = true
		cooldown = 4
		_call()
	#is_move = true

func _atac():
	_atac_flip()
	$player_hit.play()
	## damage
	$mob/Platform/mobs.visible = false
	if Global.shild == false:
		Global.player_xp -= 1
	#print(Xod.player_xp)
	Global.move_mob += 1
	move = true
	await get_tree().create_timer(0.1).timeout
	$mob/Platform/mobs.visible = true

func _player_push():
	if player_push == false:
		return
	if player.global_position == player_sprite.global_position:
		player_push = false
		#Global.move_mob += 1
		#move = true
		#stan = true
		return
	player_sprite.global_position = player_sprite.global_position.move_toward(player.global_position, 1)
	#if player.global_position != player_sprite.global_position:
		#return

func _armor():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		#_atac()
		Global.move_mob += 1
		move = true
		var pos = global_position - player.global_position
		pos = player.global_position - pos
		var push = true
		var tile = tile_map.local_to_map(pos)
		for enemy in enemies:
			if tile_map.local_to_map(enemy.global_position) == tile:
				push = false
		for decor in decors:
			if tile_map.local_to_map(decor.global_position) == tile:
				push = false
		var tile_data: TileData = tile_map.get_cell_tile_data(0, tile)
		var player_pos = player.global_position
		if tile_data.get_custom_data("walk") == true && push == true:
			player.global_position = pos
			player_sprite.global_position = player_pos
			player_push = true
		stan = true
		return
	#else:
		#Global.move_mob += 1
		#move = true
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		room += 1
		move = true
		#if dead_end != false:
		#if dead_end == false:
		#	return
		#if room >= 2:
		#	_die()
		return
	dead_end = false
	room = 0
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#print(global_position)
	sprite.global_position = original_position
	stan = true
	is_move = true

func _barrel():
	if cooldown <= 0:
		xp = 0
		return
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		#_atac()
		xp = 0
		stan = true
		return
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		room += 1
		move = true
		cooldown -= 1
		return
	dead_end = false
	cooldown -= 1
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#$AnimationPlayer.play("move")
	#print(global_position)
	sprite.global_position = original_position
	is_move = true

func _golem():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac()
		stan = true
		return
	#else:
		#Global.move_mob += 1
		#move = true
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		room += 1
		move = true
		#if dead_end != false:
		if dead_end == false:
			return
		if room >= 2:
			_die()
		return
	dead_end = false
	room = 0
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#print(global_position)
	sprite.global_position = original_position
	stan = true
	is_move = true

func _knight():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac()
		stan = true
		return
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		room += 1
		move = true
		if dead_end == false:
			return
		if room >= 2:
			_die()
		return
	dead_end = false
	room = 0
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#$AnimationPlayer.play("move")
	#print(global_position)
	sprite.global_position = original_position
	is_move = true

func _vampire():
	if cooldown == 0:
		stage += 1
		Global.move_mob += 1
		move = true
		$change_stage.play()
		$vampire_togle.emitting = true
		cooldown = 6
		return
	else:
		cooldown -= 1
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac()
		if stage % 2 == 0:
			stan = true
		return
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		room += 1
		move = true
		if dead_end == false:
			return
		if room >= 2:
			_die()
		return
	if stage % 2 == 0:
		stan = true
	dead_end = false
	room = 0
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#$AnimationPlayer.play("move")
	#print(global_position)
	sprite.global_position = original_position
	is_move = true

func _ghost():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac()
		return
	if path.is_empty() == true:
		#print("cant")
		## cant move
		Global.move_mob += 1
		move = true
		return
	var original_position = Vector2i(global_position)
	global_position = tile_map.map_to_local(path[0])
	#print(global_position)
	sprite.global_position = original_position
	is_move = true

func _atac_flip():
	if global_position.x < player.global_position.x:
		$mob/Platform/mobs/Golem.flip_h = false
		$mob/Platform/mobs/Knight.flip_h = false
		$mob/Platform/mobs/Necromant.flip_h = false
		$mob/Platform/mobs/Ghost.flip_h = false
		$mob/Platform/mobs/Armor.flip_h = false
		$mob/Platform/mobs/barrel.flip_h = false
		$mob/Platform/mobs/Slime.flip_h = false
		$mob/Platform/mobs/Skelet.flip_h = false
		$mob/Platform/mobs/Skelet.position.x = 2
		$mob/Platform/mobs/barrel.position.x = -1
		$mob/Platform/mobs/Knight.position.x = 2
		$mob/Platform/mobs/Golem.position.x = 1
		$mob/Platform/mobs/Armor.position.x = 1
	elif global_position.x > player.global_position.x:
		$mob/Platform/mobs/Golem.flip_h = true
		$mob/Platform/mobs/Knight.flip_h = true
		$mob/Platform/mobs/Necromant.flip_h = true
		$mob/Platform/mobs/Ghost.flip_h = true
		$mob/Platform/mobs/Armor.flip_h = true
		$mob/Platform/mobs/barrel.flip_h = true
		$mob/Platform/mobs/Slime.flip_h = true
		$mob/Platform/mobs/Skelet.flip_h = true
		$mob/Platform/mobs/Skelet.position.x = -2
		$mob/Platform/mobs/barrel.position.x = 1
		$mob/Platform/mobs/Knight.position.x = -2
		$mob/Platform/mobs/Golem.position.x = -1
		$mob/Platform/mobs/Armor.position.x = -1

func _flip():
	if sprite.global_position.x < global_position.x:
		$mob/Platform/mobs/Golem.flip_h = false
		$mob/Platform/mobs/Knight.flip_h = false
		$mob/Platform/mobs/Necromant.flip_h = false
		$mob/Platform/mobs/Ghost.flip_h = false
		$mob/Platform/mobs/Armor.flip_h = false
		$mob/Platform/mobs/barrel.flip_h = false
		$mob/Platform/mobs/Slime.flip_h = false
		$mob/Platform/mobs/Skelet.flip_h = false
		$mob/Platform/mobs/vampire/Vampire.flip_h = false
		$mob/Platform/mobs/vampire/Bat.flip_h = false
		$mob/Platform/mobs/vampire/Bat.position.x = -1
		$mob/Platform/mobs/Skelet.position.x = 2
		$mob/Platform/mobs/barrel.position.x = -1
		$mob/Platform/mobs/Knight.position.x = 2
		$mob/Platform/mobs/Golem.position.x = 1
		$mob/Platform/mobs/Armor.position.x = 1
	elif sprite.global_position.x > global_position.x:
		$mob/Platform/mobs/Golem.flip_h = true
		$mob/Platform/mobs/Knight.flip_h = true
		$mob/Platform/mobs/Necromant.flip_h = true
		$mob/Platform/mobs/Ghost.flip_h = true
		$mob/Platform/mobs/Armor.flip_h = true
		$mob/Platform/mobs/barrel.flip_h = true
		$mob/Platform/mobs/Slime.flip_h = true
		$mob/Platform/mobs/Skelet.flip_h = true
		$mob/Platform/mobs/vampire/Vampire.flip_h = true
		$mob/Platform/mobs/vampire/Bat.flip_h = true
		$mob/Platform/mobs/vampire/Bat.position.x = 1
		$mob/Platform/mobs/Skelet.position.x = -2
		$mob/Platform/mobs/barrel.position.x = 1
		$mob/Platform/mobs/Knight.position.x = -2
		$mob/Platform/mobs/Golem.position.x = -1
		$mob/Platform/mobs/Armor.position.x = -1

func _physics_process(_delta):
	## die
	_player_push()
	_mob()
	if xp <= 0 && die == false:
		_die()
		return
	if is_spawn == true:
		sprite.global_position = sprite.global_position.move_toward(global_position, 3)
		_flip()
		#Global.move_mob += 1
		if sprite.global_position != global_position:
			return
		start_position = sprite.global_position
		if nomber == Global.rand:
			Global.spawner = false
		is_spawn = false
		$Shadow.visible = false
		$enemy/CollisionShape2D.disabled = false
		#move = true
	## move
	if is_move == true:
		sprite.global_position = sprite.global_position.move_toward(global_position, 1)
		_flip()
		if sprite.global_position != global_position:
			return
		start_position = sprite.global_position
		Global.move_mob += 1
		is_move = false
		move = true
	## animation
	if Global.xod_player == true && stan == false && die == false && Global.player_die == false && Global.reset == false:
		$AnimationPlayer.play("shake")
		if mob == "vampire" && cooldown == 0 && die == false:
			$vampire.emitting = true
			$vampire_stage.play()
		elif mob == "vampire" && (cooldown != 0 || die == true):
			$vampire.emitting = false
#		anim_position = Vector2(start_position.x + shift, sprite.global_position.y)
#		sprite.global_position = sprite.global_position.move_toward(anim_position, 0.2)
#		if sprite.global_position != anim_position:
#			return
#		shift *= -1

func _spawn_coin():
	var rand = randi_range(0, 10)
	#print(rand)
	if rand <= 2 * Global.factor_coin:
		var temp_coin = coin.instantiate()
		$"..".add_child(temp_coin)
		temp_coin.global_position = sprite.global_position
	elif rand == 8:
		var temp_bonus = bonus.instantiate()
		$"..".add_child(temp_bonus)
		temp_bonus.global_position = sprite.global_position

func _die():
	die = true
	if mob == "vampire":
		$vampire.emitting = false
	if spawner == true:
		#spawn_vase = false
		#Global.quantity_mob -= 1
		await get_tree().create_timer(0.15).timeout
		queue_free()
		return
	#if mob == "necromant":
		#Global.player_xp += 1
	if mob == "barrel":
		$boom2.emitting = true
		$boom.play()
		$barrel/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.18).timeout
	$barrel/CollisionShape2D.disabled = true
	#print(1)
	_spawn_coin()
	Global.quantity_mob -= 1
	var nomb_y: int = nomber / 10
	var nomb_x = nomber % 10
	if nomb_x <= 5 && nomb_x != 0:
		global_position = (Vector2(-72 + (nomb_x - 1) * 16, 152 + nomb_y * 16))
	elif nomb_x != 0:
		global_position = (Vector2(200 + (nomb_x - 6) * 16, 152 + nomb_y * 16))
	else:
		global_position = (Vector2(200 + (nomb_x + 4) * 16, 152 + (nomb_y - 1) * 16))
	if Global.place == "tutorial":
		_tutor_die()

func _hit():
	$hit.play("hit")
	#Global.hit = true
	#await get_tree().create_timer(0.1).timeout
	#Global.hit = false

func _on_enemy_area_entered(area):
	#if area.name == "tnt":
	#	xp -= 1
	if area.name == "die":
		xp = 0
		return
	if mob == "armor":
		if area.name == "spikes" || area.name == "trap" \
		|| area.name == "bomba" || area.name == "barrel" \
		|| area.name == "player":
			$AudioStreamPlayer.play()
			_hit()
			return
	if mob == "vampire" && stage % 2 == 0:
		if area.name == "spikes" || area.name == "trap" \
		|| area.name == "player":
			$hit_bat.play()
			return
	if mob != "ghost":
		if area.name == "spikes" || area.name == "trap":
			$AudioStreamPlayer.play()
			_hit()
			await get_tree().create_timer(0.1).timeout
			xp -= 1
			if mob == "necromant" && xp != 0:
				_tp()
			#print(1)
	if area.name == "bomba" || area.name == "barrel":
		_hit()
		if mob == "necromant":# && xp != 0:
			#_tp()
			xp -= 1
		await get_tree().create_timer(0.1).timeout
		xp -= 1
	if area.name == "player":
		#await get_tree().create_timer(0.1).timeout
		$AudioStreamPlayer.play()
		_hit()
		if Global.one_shot == true:
			xp = 1
		xp -= 1
		if mob == "necromant" && xp != 0:
			_tp()

func _mob():
	if mob == "knight":
		$mob/Platform/mobs/Knight.visible = true
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Ghost.visible = false
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif mob == "golem":
		$mob/Platform/mobs/Golem.visible = true
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Ghost.visible = false
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif  mob == "ghost":
		$mob/Platform/mobs/Ghost.visible = true
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif mob == "necromant":
		$mob/Platform/mobs/Necromant.visible = true
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Ghost.visible = false
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif mob == "armor":
		$mob/Platform/mobs/Armor.visible = true
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Ghost.visible = false
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif mob == "barrel":
		$mob/Platform/mobs/barrel.visible = true
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Ghost.visible = false
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif mob == "slime":
		$mob/Platform/mobs/Slime.visible = true
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Ghost.visible = false
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif mob == "skelet":
		$mob/Platform/mobs/Skelet.visible = true
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Ghost.visible = false
		$mob/Platform/mobs/vampire.visible = false
	elif mob == "vampire":
		$mob/Platform/mobs/vampire.visible = true
		if stage % 2 == 1:
			$mob/Platform/mobs/vampire/Vampire.visible = true
			$mob/Platform/mobs/vampire/Bat.visible = false
		else:
			$mob/Platform/mobs/vampire/Vampire.visible = false
			$mob/Platform/mobs/vampire/Bat.visible = true
		$mob/Platform/mobs/Skelet.visible = false
		$mob/Platform/mobs/Slime.visible = false
		$mob/Platform/mobs/barrel.visible = false
		$mob/Platform/mobs/Armor.visible = false
		$mob/Platform/mobs/Necromant.visible = false
		$mob/Platform/mobs/Golem.visible = false
		$mob/Platform/mobs/Knight.visible = false
		$mob/Platform/mobs/Ghost.visible = false

func _spawn():
	if Global.place != "game":
		return
	#if die == false && nomber == Global.spawn_mob:
		#Global.spawn_mob += 1
		#Global.rand += 1
	if nomber > Global.rand:
		return
	if nomber != Global.spawn_mob:
		return
	$enemy/CollisionShape2D.disabled = true
	$spawn.start(0.1)
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var x = randi_range(1, 10) * 16 + 8
	var y = randi_range(1, 9) * 16 + 8
	var spawn_tile: Vector2i = tile_map.local_to_map(Vector2(x, y))
	#var data = tile_map.get_cell_tile_data(0, spawn_tile)
	var spawn: bool
	while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || spawn == false:
		#print(spawn)
		#while spawn == false:
		#path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
		spawn = true
		x = randi_range(1, Global.tile_max.x) * 16 + 8
		y = randi_range(1, Global.tile_max.y) * 16 + 8
		spawn_tile = tile_map.local_to_map(Vector2(x, y))
		#if tile_map.local_to_map(Vector2(x, 0)) > tile_map.local_to_map(player.global_position):
			#spawn = false
		for enemy in enemies:
			if enemy == self:
				continue
			if spawn_tile == tile_map.local_to_map(enemy.global_position):
				spawn = false
		for decor in decors:
			if spawn_tile == tile_map.local_to_map(decor.global_position):
				spawn = false
		#data = tile_map.get_cell_tile_data(0, spawn_tile)
	var rand = randi_range(0,100)
	#print(rand)
	if rand <= 15:
		mob = "vampire"
		xp = 1
		cooldown = 6
	elif rand <= 30:
		mob = "golem"
		xp = 3
	elif rand <= 45:
		mob = "knight"
		xp = 1
	elif rand <= 65:
		mob = "barrel"
		xp = 1
		cooldown = 5
	elif rand <= 70:
		mob = "necromant"
		xp = 2
		cooldown = 4
	elif rand <= 85 && Global.quantity_armor < 2:
		mob = "armor"
		xp = 1
		Global.quantity_armor += 1
	elif rand > 85:
		mob = "ghost"
		xp = 1
	else:
		mob = "knight"
		xp = 1
	global_position = Vector2(x, y - 200)
	$Shadow.visible = true
	$AnimationPlayer.play("shadow")
	var pos = global_position
	global_position = Vector2(x, y)
	sprite.global_position = pos
	#is_move = true
	#prints(position, global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(spawn_tile))
	is_spawn = true
	stan = true
	dead_end = true
	die = false
	#print(spawn_tile)
	Global.quantity_mob += 1
	start_position = sprite.global_position
	if nomber == 1:
		Global.wave += 1
	#_dead_end()
	#print(Global.quantity_mob)

func _dead_end():
	if mob == "ghost":
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.is_empty() == true:
		#print("cant")
		## cant move
		xp = 0

func _tutor_die():
	if mob == "knight":
		global_position = $"../../buttons/button_knight/knight_die".global_position
	if mob == "golem":
		global_position = $"../../buttons/button_golem/golem_die".global_position
	if mob == "ghost":
		global_position = $"../../buttons/button_ghost/ghost_die".global_position
	if mob == "necromant":
		global_position = $"../../buttons/button_necromant/necromant_die".global_position
	if mob == "barrel":
		global_position = $"../../buttons/button_barrel/barrel_die".global_position
	if mob == "vampire":
		global_position = $"../../buttons/button_vampire/vampire_die".global_position

func _on_spawn_timeout():
	Global.spawn_mob += 1
