extends Node2D

@export var enviroment: PackedScene
@export var shest: PackedScene
@onready var tile_map = $"../../TileMap"
@onready var player = $"../player"
var spawner = false
var wave = 0
#@export var tile_max = Vector2i(10, 9)

func _ready():
	#await get_tree().create_timer(0.1).timeout
	#Global.tile_max = tile_max
	var rand = randi_range(20, 30)
	for i in range(0, rand):
		var temp_decor = enviroment.instantiate()
		add_child(temp_decor)
		var x = randi_range(1, Global.tile_max.x) * 16 + 8
		var y = randi_range(1, Global.tile_max.y) * 16 + 8
		var spawn: bool
		var data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(Vector2(x, y)))
		var decors = get_tree().get_nodes_in_group("decors")
		while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || spawn == false:
			spawn = true
			x = randi_range(1, Global.tile_max.x) * 16 + 8
			y = randi_range(1, Global.tile_max.y) * 16 + 8
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

func _process(_delta):
	var rand = 1000
	if wave < Global.wave && Global.wave > 5:
		wave = Global.wave
		rand = randi_range(0, 100)
		#print(rand)
	await get_tree().create_timer(0.1).timeout
	if Global.shest == false && rand <= 15:
		Global.shest = true
		var temp_shest = shest.instantiate()
		add_child(temp_shest)
		var decors = get_tree().get_nodes_in_group("decors")
		var enemies = get_tree().get_nodes_in_group("enemies")
		var spawn: bool
		var x = randi_range(1, Global.tile_max.x) * 16 + 8
		var y = randi_range(1, Global.tile_max.y) * 16 + 8
		var data = tile_map.get_cell_tile_data(0, tile_map.local_to_map(Vector2(x, y)))
		while tile_map.local_to_map(Vector2(x, y)) ==  tile_map.local_to_map(player.global_position) || spawn == false:
			spawn = true
			x = randi_range(1, Global.tile_max.x) * 16 + 8
			y = randi_range(1, Global.tile_max.y) * 16 + 8
			for decor in decors:
				if tile_map.local_to_map(Vector2(x, y)) == tile_map.local_to_map(decor.global_position):
					spawn = false
					#print(spawn)
			if data == null or not data.get_custom_data("walk"):
				spawn = false
				continue
		temp_shest.global_position = Vector2(x, y)

