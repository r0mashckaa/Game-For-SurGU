extends Node

var xod_player = true
var player_xp = 30
var quantity_mob = 0
var nomber_mob = 1
var move_mob = 0
var rand: int
var spawn = false

func _process(delta):
	if move_mob >= quantity_mob:
		move_mob = 0
		xod_player = true
	if quantity_mob <= 0:
		rand = randi_range(2, 4)
		spawn = true
		#print(rand)
	if quantity_mob >= rand:
		spawn = false
		#print(spawn)
	#print(quantity_mob)
#var player_pos
#@onready var tile_map = $"../TileMap"
#@onready var player = $"../player"
