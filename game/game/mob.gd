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

func _ready():
	#Xod.quantity_mob += 1
	nomber = Global.nomber_mob
	Global.nomber_mob += 1
	$Label.text = (str(nomber))
	await get_tree().create_timer(0.5).timeout
	#print(Xod.player_xp)
	#print(Xod.quantity_mob)
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
		#Xod.xod_player = true
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
		astar_grid.set_point_solid(occupied_position)
	var path = astar_grid.get_id_path(tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	#prints(global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(player.global_position))
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		$Platform/Golem.visible = false
		stan = true
		Global.player_xp -= 1
		#print(Xod.player_xp)
		#Xod.xod_player = true
		Global.move_mob += 1
		move = true
		await get_tree().create_timer(0.1).timeout
		$Platform/Golem.visible = true
		return
	if path.is_empty():
		#print("cant")
		#Xod.xod_player = true
		Global.move_mob += 1
		move = true
		return
	if tile_map.local_to_map(Vector2(global_position.x, 0)) < tile_map.local_to_map(Vector2(player.global_position.x, 0)):
		$Platform/Golem.flip_h = false
		$Platform/Golem.position.x = 1
	elif tile_map.local_to_map(Vector2(global_position.x, 0)) > tile_map.local_to_map(Vector2(player.global_position.x, 0)):
		$Platform/Golem.flip_h = true
		$Platform/Golem.position.x = -1
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#print(global_position)
	sprite.global_position = original_position
	is_move = true

func _physics_process(delta):
	#if Xod.spawn == true && die == true:
		#print("spawn")
		#if nomber != Xod.nomber_mob:
			#return
		
		#global_position = tile_map.local_to_map(Xod.spawn_tile)
		#die = false
		#Xod.xod_player = true
		#return
	
	if is_move == true:
		
		sprite.global_position = sprite.global_position.move_toward(global_position, 1)
		if sprite.global_position != global_position:
			return
		is_move = false
		#Xod.xod_player = true
		Global.move_mob += 1
		move = true


func _on_enemy_area_entered(area):
	if area.name == "player":
		die =true
		Global.quantity_mob -= 1
		#stan = true
		global_position = (Vector2(184 + (nomber -1) * 16, 136))
		#print(tile_map.local_to_map(Vector2(1840, 1360)))
		#print(global_position)
		#queue_free()

func _spawn():
	if nomber > Global.rand:
		return
	var x = randi_range(0, 9) * 16 + 8
	var y = randi_range(0, 8) * 16 + 8
	var spawn_tile: Vector2i = tile_map.local_to_map(Vector2(x, y))
	var data = tile_map.get_cell_tile_data(0, spawn_tile)
	while null || not data.get_custom_data("walk") || tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position):
		x = randi_range(0, 9) * 16 + 8
		y = randi_range(0, 8) * 16 + 8
		spawn_tile = tile_map.local_to_map(Vector2(x, y))
		data = tile_map.get_cell_tile_data(0, spawn_tile)
		#var x = randi_range(0, 160)
		#var y = randi_range(0, 144)
	global_position = Vector2(x, y)
	#prints(position, global_position, tile_map.local_to_map(global_position), tile_map.local_to_map(spawn_tile))
	die = false
	stan = true
	#print(spawn_tile)
	#Xod.spawn_tile = spawn_tile
	Global.quantity_mob += 1
	if nomber == 1:
		Global.wave += 1
	#print(Xod.quantity_mob)
