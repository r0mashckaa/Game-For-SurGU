extends CharacterBody2D

@onready var tile_map = Global.tile_map

func _process(delta):
	_get_input()

func _get_input():
	if Input.is_action_pressed("up"):
		_move(Vector2.UP)
	elif Input.is_action_pressed("down"):
		_move(Vector2.DOWN)
	elif Input.is_action_pressed("left"):
		_move(Vector2.LEFT)
	elif Input.is_action_pressed("ridht"):
		_move(Vector2.RIGHT)

func _move(direction: Vector2):
	var curret_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		curret_tile.x + direction.x,
		curret_tile.y + direction.y,
	)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if tile_data.get_custom_data("walk") == false:
		return
	global_position = tile_map.map_to_local(target_tile)
