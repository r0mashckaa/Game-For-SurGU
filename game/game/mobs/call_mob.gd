extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var player = $"../../player"
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
@onready var call_mobs = get_tree().get_nodes_in_group("call_mobs")
var anim_position: Vector2
var start_position: Vector2
var dead_end
var cooldown = 3

func _ready():
	nomber = Global.nomber_call_mob
	global_position = Vector2(184 + (nomber - 1) * 16, -8)
	Global.nomber_call_mob += 1
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
	if Global.nomber_call_mob == nomber && die == false:
		Global.nomber_call_mob += 1
	if die == true:
		if Global.call == true:
			_call()
		return
	if is_move == true:
		return
	if Global.xod_player == true:
		move = false
		return
	if move == true:
		return
	_move()

func _die():
	die = true
	Global.quantity_call_mob -= 1
	global_position = Vector2(184 + (nomber - 1) * 16, -8)

func _flip():
	if sprite.global_position.x < global_position.x:
		$Platform/Skelet.flip_h = false
		$Platform/Skelet.position.x = 2
	elif sprite.global_position.x > global_position.x:
		$Platform/Skelet.flip_h = true
		$Platform/Skelet.position.x = -2

func _move():
	if stan == true:
		#Global.move_mob += 1
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
		## damage
		$Platform.visible = false
		stan = true
		Global.player_xp -= 1
		#print(Xod.player_xp)
		#Global.move_mob += 1
		move = true
		await get_tree().create_timer(0.1).timeout
		$Platform.visible = true
		return
	else:
		#Global.move_mob += 1
		move = true
	if path.is_empty() == true:
		#print("cant")
		## cant move
		#Global.move_mob += 1
		room += 1
		move = true
		#if dead_end != false:
		#if dead_end == false:
			#return
		#if room >= 2:
			#_die()
		return
	#dead_end = false
	#room = 0
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	#print(global_position)
	sprite.global_position = original_position
	stan = true
	is_move = true

func _physics_process(_delta):
	## die
	if (xp <= 0 && die == false) || Global.player_die == true:
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

func _call():
	if nomber == Global.nomber_call_mob:
		stan = true
		Global.call = false
		die = false
		xp = 1
		Global.quantity_call_mob += 1
		Global.nomber_call_mob += 1
		#print(Global.quantity_call_mob)
		global_position = tile_map.map_to_local(Global.call_tile)
		start_position = sprite.global_position


func _on_call_mob_area_entered(area):
	if area.name == "player":
		xp -= 1
