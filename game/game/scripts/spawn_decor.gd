extends Node2D

@export var enviroment: PackedScene
@onready var tile_map = $"../../TileMap"
@onready var player = $"../player"
var spawner = false

func _ready():
	var rand = randi_range(20, 30)
	for i in range(0, rand):
		var temp_decor = enviroment.instantiate()
		add_child(temp_decor)
		var x = randi_range(1, 10) * 16 + 8
		var y = randi_range(1, 9) * 16 + 8
		var spawn: bool
		var data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(Vector2(x, y)))
		var decors = get_tree().get_nodes_in_group("decors")
		while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || spawn == false:
			spawn = true
			x = randi_range(1, 10) * 16 + 8
			y = randi_range(1, 9) * 16 + 8
			for decor in decors:
				if tile_map.local_to_map(Vector2(x, y)) == tile_map.local_to_map(decor.global_position):
					spawn = false
					#print(spawn)
			if data == null or not data.get_custom_data("walk"):
				spawn = false
				continue
		temp_decor.global_position = Vector2(x, y)
		#print(i)
	#prints("rand", rand)

