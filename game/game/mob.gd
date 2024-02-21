extends Node2D

@onready var tile_map = $"../TileMap"
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
@onready var enemies = get_tree().get_nodes_in_group("enemies")
@onready var decors = get_tree().get_nodes_in_group("decors")
var anim_position: Vector2
var start_position: Vector2
var dead_end
var path

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

func _process(delta):
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
	_move()

func _move():
	if stan == true:
		Global.move_mob += 1
		#await get_tree().create_timer(1).timeout
		stan = false
		move = true
		return
	var occupied_positions = []
	for enemy in enemies:
		if enemy == self:
			continue
		occupied_positions.append(tile_map.local_to_map(enemy.global_position))
	for decor in decors:
		occupied_positions.append(tile_map.local_to_map(decor.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
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
		#if dead_end != false:
		if room >= 10:
			_die()
		return
	#dead_end = false
	room = 0
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#print(global_position)
	sprite.global_position = original_position
	if mob == "golem":
		stan = true
	is_move = true

func _flip():
	if sprite.global_position.x < global_position.x:
		$Platform/mobs/Golem.flip_h = false
		$Platform/mobs/Knight.flip_h = false
		$Platform/mobs/Knight.position.x = 2
		$Platform/mobs/Golem.position.x = 1
	elif sprite.global_position.x > global_position.x:
		$Platform/mobs/Golem.flip_h = true
		$Platform/mobs/Knight.flip_h = true
		$Platform/mobs/Knight.position.x = -2
		$Platform/mobs/Golem.position.x = -1

func _physics_process(delta):
	## die
	if xp <= 0 && die == false:
		_die()
	## move
	if is_move == true:
		sprite.global_position = sprite.global_position.move_toward(global_position, 1)
		_flip()
		if sprite.global_position != global_position:
			return
		start_position = sprite.global_position
		is_move = false
		Global.move_mob += 1
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
	Global.quantity_mob -= 1
	global_position = (Vector2(184 + (nomber -1) * 16, 136))

func _on_enemy_area_entered(area):
	if area.name == "player":
		xp -= 1

func _spawn():
	if nomber > Global.rand:
		return
	var x = randi_range(0, 9) * 16 + 8
	var y = randi_range(0, 8) * 16 + 8
	var spawn_tile: Vector2i = tile_map.local_to_map(Vector2(x, y))
	var data = tile_map.get_cell_tile_data(0, spawn_tile)
	var spawn: bool
	while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || spawn == false || path.is_empty() == false:
		#print(spawn)
		#while spawn == false:
		path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
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
		data = tile_map.get_cell_tile_data(0, spawn_tile)
	var rand = randi_range(0,100)
	if rand <= 30:
		mob = "golem"
		$Platform/mobs/Golem.visible = true
		$Platform/mobs/Knight.visible = false
		xp = 2
	elif rand > 30:
		mob = "knight"
		$Platform/mobs/Knight.visible = true
		$Platform/mobs/Golem.visible = false
		xp = 1
	
	global_position = Vector2(x, y)
	#prints(position, global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(spawn_tile))
	die = false
	stan = true
	#print(spawn_tile)
	Global.quantity_mob += 1
	start_position = sprite.global_position
	if nomber == 1:
		Global.wave += 1
	#print(Global.quantity_mob)
