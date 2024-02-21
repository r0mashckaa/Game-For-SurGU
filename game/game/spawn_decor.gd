extends Node2D

@export var enviroment: PackedScene
@onready var tile_map = $"../TileMap"
@onready var player = $"../player"
@onready var decors = get_tree().get_nodes_in_group("decors")

func _ready():
	var rand = randi_range(20, 30)
	for i in range(0, rand):
		var temp_decor = enviroment.instantiate()
		add_child(temp_decor)
		var x = randi_range(0, 9) * 16 + 8
		var y = randi_range(0, 8) * 16 + 8
		var spawn: bool
		var data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(Vector2(x, y)))
		while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || spawn == false:
			spawn = true
			x = randi_range(0, 9) * 16 + 8
			y = randi_range(0, 8) * 16 + 8
			for decor in decors:
				if tile_map.local_to_map(Vector2(x, y)) == tile_map.local_to_map(decor.global_position):
					spawn = false
					print(spawn)
			
		temp_decor.global_position = Vector2(x, y)
