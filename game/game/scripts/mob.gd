extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var player = $"../player"
@onready var sprite = $Platform
var astar_grid: AStarGrid2D
var is_move: bool
var stan: bool
var nomber
var move: bool
var die = true
var xp = 1
var room = 0
var shift = 1
var animca: bool
var mob: String
var anim_position: Vector2
var start_position: Vector2
var dead_end
var cooldown = 3

func _ready():
	nomber = Global.nomber_mob
	Global.nomber_mob += 1
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

func _process(_delta):
	if Global.reset_player == true:
		stan = true
		return
	if die == true:
		if Global.spawn == true:
			#print("spawn")
			_spawn()
		return
	if is_move == true:
		return
	if Global.xod_player == true:
		move = false
		return
	if move == true:
		return
	if mob == "knight":
		_knight()
	elif mob == "golem":
		_golem()
	elif mob == "necromant":
		_necromant()
	elif mob == "ghost":
		_ghost()

func _tp():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var call_mobs = get_tree().get_nodes_in_group("call_mobs")
	var x = randi_range(0, 9) * 16 + 8
	var y = randi_range(0, 8) * 16 + 8
	var tp_tile: Vector2i = tile_map.local_to_map(Vector2(x, y))
	var data = tile_map.get_cell_tile_data(0, tp_tile)
	var tp: bool
	while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || tp == false:
		tp = true
		x = randi_range(0, 9) * 16 + 8
		y = randi_range(0, 8) * 16 + 8
		tp_tile = tile_map.local_to_map(Vector2(x, y))
		for enemy in enemies:
			if enemy == self:
				continue
			if tp_tile == tile_map.local_to_map(enemy.global_position):
				tp = false
		for decor in decors:
			if tp_tile == tile_map.local_to_map(decor.global_position):
				tp = false
		for call_mob in call_mobs:
			if tp_tile == tile_map.local_to_map(call_mob.global_position):
				tp = false
		if data == null or not data.get_custom_data("walk"):
			tp = false
			continue
		#data = tile_map.get_cell_tile_data(0, tp_tile)
	global_position = Vector2(x, y)
	sprite.global_position = global_position
	start_position = sprite.global_position
	dead_end = true
	stan = true
	cooldown = 3

func _call():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var call_mobs = get_tree().get_nodes_in_group("call_mobs")
	var x = randi_range(-1, 1)# * 16 + 8
	var y = randi_range(-1, 1)# * 16 + 8
	var call_tile: Vector2i = Vector2i(tile_map.local_to_map(global_position).x + x, tile_map.local_to_map(global_position).y + y)
	var data = tile_map.get_cell_tile_data(0, call_tile)
	var calling: bool
	while tile_map.local_to_map(call_tile) == tile_map.local_to_map(player.global_position) || calling == false:
		calling = true
		x = randi_range(-1, 1)
		y = randi_range(-1, 1)
		if x == 0 && y == 0:
			calling = false
			continue
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
		for call_mob in call_mobs:
			if call_tile == tile_map.local_to_map(call_mob.global_position):
				calling = false
		data = tile_map.get_cell_tile_data(0, call_tile)
		if data == null or not data.get_custom_data("walk"):
			calling = false
			continue
	#Global.quantity_call_mob += 1
	#print(Global.call)
	if Global.call == false:
		Global.nomber_call_mob = 1
		Global.call = true
		Global.call_tile = call_tile
	#await get_tree().create_timer(0.4).timeout
	#$call.global_position = tile_map.map_to_local(call_tile)
	#sprite.global_position = global_position
	#start_position = sprite.global_position
	#prints(tile_map.local_to_map(global_position), tile_map.local_to_map(call_tile))

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
	var call_mobs = get_tree().get_nodes_in_group("call_mobs")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for call_mob in call_mobs:
		occupied_positions.append(tile_map.local_to_map(call_mob.global_position))
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
		Global.move_mob += 1
		move = true
		if stan == true:
			return
		await get_tree().create_timer(0.1).timeout
		stan = true
		cooldown = 4
		_call()
	#is_move = true

func _golem():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var call_mobs = get_tree().get_nodes_in_group("call_mobs")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for call_mob in call_mobs:
		occupied_positions.append(tile_map.local_to_map(call_mob.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac_flip()
		## damage
		$Platform/mobs.visible = false
		stan = true
		Global.player_xp -= 1
		#print(Xod.player_xp)
		Global.move_mob += 1
		move = true
		await get_tree().create_timer(0.1).timeout
		$Platform/mobs.visible = true
		return
	else:
		Global.move_mob += 1
		move = true
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
	var call_mobs = get_tree().get_nodes_in_group("call_mobs")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for call_mob in call_mobs:
		occupied_positions.append(tile_map.local_to_map(call_mob.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac_flip()
		## damage
		$Platform/mobs.visible = false
		stan = true
		Global.player_xp -= 1
		#print(Xod.player_xp)
		Global.move_mob += 1
		move = true
		await get_tree().create_timer(0.1).timeout
		$Platform/mobs.visible = true
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
	var call_mobs = get_tree().get_nodes_in_group("call_mobs")
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for call_mob in call_mobs:
		occupied_positions.append(tile_map.local_to_map(call_mob.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		_atac_flip()
		## damage
		$Platform/mobs.visible = false
		#stan = true
		Global.player_xp -= 1
		#print(Xod.player_xp)
		Global.move_mob += 1
		move = true
		await get_tree().create_timer(0.1).timeout
		$Platform/mobs.visible = true
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
		$Platform/mobs/Golem.flip_h = false
		$Platform/mobs/Knight.flip_h = false
		$Platform/mobs/Necromant.flip_h = false
		$Platform/mobs/Ghost.flip_h = false
		$Platform/mobs/Knight.position.x = 2
		$Platform/mobs/Golem.position.x = 1
	elif global_position.x > player.global_position.x:
		$Platform/mobs/Golem.flip_h = true
		$Platform/mobs/Knight.flip_h = true
		$Platform/mobs/Necromant.flip_h = true
		$Platform/mobs/Ghost.flip_h = true
		$Platform/mobs/Knight.position.x = -2
		$Platform/mobs/Golem.position.x = -1

func _flip():
	if sprite.global_position.x < global_position.x:
		$Platform/mobs/Golem.flip_h = false
		$Platform/mobs/Knight.flip_h = false
		$Platform/mobs/Necromant.flip_h = false
		$Platform/mobs/Ghost.flip_h = false
		$Platform/mobs/Knight.position.x = 2
		$Platform/mobs/Golem.position.x = 1
	elif sprite.global_position.x > global_position.x:
		$Platform/mobs/Golem.flip_h = true
		$Platform/mobs/Knight.flip_h = true
		$Platform/mobs/Necromant.flip_h = true
		$Platform/mobs/Ghost.flip_h = true
		$Platform/mobs/Knight.position.x = -2
		$Platform/mobs/Golem.position.x = -1

func _physics_process(_delta):
	## die
	_mob()
	_tutor_spawn()
	if xp <= 0 && die == false:
		_die()
	## move
	if is_move == true:
		sprite.global_position = sprite.global_position.move_toward(global_position, 1)
		_flip()
		Global.move_mob += 1
		if sprite.global_position != global_position:
			return
		start_position = sprite.global_position
		is_move = false
		
		move = true
	## animation
	if Global.xod_player == true && stan == false && die == false && Global.player_die == false && Global.reset == false:
		anim_position = Vector2(start_position.x + shift, sprite.global_position.y)
		sprite.global_position = sprite.global_position.move_toward(anim_position, 0.2)
		if sprite.global_position != anim_position:
			return
		shift *= -1

func _die():
	die = true
	#if mob == "necromant":
		#Global.player_xp += 1
	Global.quantity_mob -= 1
	if nomber <= 5:
		global_position = (Vector2(-88 + (nomber - 1) * 16, 136))
	else:
		global_position = (Vector2(184 + (nomber - 6) * 16, 136))
	if Global.place == "tutorial":
		tutor_die()
		

func _on_enemy_area_entered(area):
	if area.name == "player":
		xp -= 1
		if mob == "necromant":
			_tp()

func _mob():
	if mob == "knight":
		$Platform/mobs/Knight.visible = true
		$Platform/mobs/Golem.visible = false
		$Platform/mobs/Necromant.visible = false
		$Platform/mobs/Ghost.visible = false
	elif mob == "golem":
		$Platform/mobs/Golem.visible = true
		$Platform/mobs/Knight.visible = false
		$Platform/mobs/Necromant.visible = false
		$Platform/mobs/Ghost.visible = false
	elif  mob == "ghost":
		$Platform/mobs/Ghost.visible = true
		$Platform/mobs/Golem.visible = false
		$Platform/mobs/Knight.visible = false
		$Platform/mobs/Necromant.visible = false
	elif mob == "necromant":
		$Platform/mobs/Necromant.visible = true
		$Platform/mobs/Golem.visible = false
		$Platform/mobs/Knight.visible = false
		$Platform/mobs/Ghost.visible = false

func _spawn():
	if Global.place != "game":
		return
	if nomber > Global.rand:
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var decors = get_tree().get_nodes_in_group("decors")
	var call_mobs = get_tree().get_nodes_in_group("call_mobs")
	var x = randi_range(0, 9) * 16 + 8
	var y = randi_range(0, 8) * 16 + 8
	var spawn_tile: Vector2i = tile_map.local_to_map(Vector2(x, y))
	#var data = tile_map.get_cell_tile_data(0, spawn_tile)
	var spawn: bool
	while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || spawn == false:
		#print(spawn)
		#while spawn == false:
		#path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
		spawn = true
		x = randi_range(0, 9) * 16 + 8
		y = randi_range(0, 8) * 16 + 8
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
		for spawn_mob in call_mobs:
			if spawn_tile == tile_map.local_to_map(spawn_mob.global_position):
				spawn = false
		#data = tile_map.get_cell_tile_data(0, spawn_tile)
	var rand = randi_range(0,100)
	#print(rand)
	if rand <= 30:
		mob = "golem"
		xp = 3
	elif rand <= 65:
		mob = "knight"
		xp = 1
	elif rand <= 75:
		mob = "necromant"
		xp = 2
	elif rand > 75:
		mob = "ghost"
		xp = 1
	global_position = Vector2(x, y)
	#prints(position, global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(spawn_tile))
	die = false
	stan = true
	dead_end = true
	#print(spawn_tile)
	Global.quantity_mob += 1
	start_position = sprite.global_position
	if nomber == 1:
		Global.wave += 1
	#print(Global.quantity_mob)

func _tutor_spawn():
	if Global.place == "tutorial":
		if nomber == 1:
			mob = "knight"
		elif nomber == 2:
			mob = "golem"
		if Global.knight_spawn == true && die == true && mob == "knight":
			global_position = $"../../buttons/button_knight/knight_spawn".global_position
			xp = 1
			Global.knight_spawn = false
			die = false
			stan = true
			Global.quantity_mob += 1
			start_position = sprite.global_position
		if Global.golem_spawn == true && die == true && mob == "golem":
			global_position = $"../../buttons/button_golem/golem_spawn".global_position
			xp = 3
			Global.golem_spawn = false
			die = false
			stan = true
			Global.quantity_mob += 1
			start_position = sprite.global_position

func tutor_die():
	if mob == "knight":
		global_position = $"../../buttons/button_knight/knight_die".global_position
	if mob == "golem":
		global_position = $"../../buttons/button_golem/golem_die".global_position
