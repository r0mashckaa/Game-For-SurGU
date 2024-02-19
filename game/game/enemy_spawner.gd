extends Node2D

@export var mob: PackedScene
@onready var tile_map = $"../TileMap"
var spawn = false


var wave = 0

func _process(delta):
	if Xod.quantity_mob != 1:
		return
	spawn = true
	Xod.spawn = spawn
	#print(Xod.spawn)
	if spawn == false:
		return
	spawn = false
	_spawn()

func _spawn():
	var rand = randi_range(2, 4)
	print(rand)
	for i in range(1, rand):
		Xod.nomber_mob = i
		#print(i)
		#var mobtemp = mob.instantiate()
		var x = randi_range(8, 152)
		var y = randi_range(8, 136)
		var spawn_tile: Vector2i = tile_map.local_to_map(Vector2(x, y))
		#print(spawn_tile)
		Xod.spawn_tile = spawn_tile
		#mobtemp.position = spawn_tile
		#add_child(mobtemp)
	Xod.spawn = spawn

