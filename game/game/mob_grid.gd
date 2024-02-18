extends Node2D

@onready var tile_map = $"../TileMap"
@onready var player = $"../player"
@onready var sprite = $Platform
var astar_grid: AStarGrid2D
var is_move: bool
var stan: bool

func _ready():
	print(Xod.player_xp)
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
	if is_move == true:
		return
	if Xod.xod_player == true:
		return
	_move()

func _move():
	if stan == true:
		stan = false
		Xod.xod_player = true
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
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	path.pop_front()
	if path.size() == 1:
		#print("i have")
		$Platform/Golem.visible = false
		Xod.player_xp -= 1
		print(Xod.player_xp)
		stan = true
		Xod.xod_player = true
		await get_tree().create_timer(0.1).timeout
		$Platform/Golem.visible = true
		return
	if path.is_empty():
		#print("cant")
		Xod.xod_player = true
		return
	var original_position = Vector2(global_position)
	global_position = tile_map.map_to_local(path[0])
	sprite.global_position = original_position
	is_move = true

func _physics_process(delta):
	if is_move == true:
		sprite.global_position = sprite.global_position.move_toward(global_position, 1)
		if sprite.global_position != global_position:
			return
		is_move = false
		Xod.xod_player = true


func _on_enemy_area_entered(area):
	if area.name == "player":
		queue_free()
