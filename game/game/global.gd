extends Node

var xod_player = false
var player_xp: int
var quantity_mob = 0
var nomber_mob = 1
var move_mob = 0
var rand: int
var spawn = false
var wave = 0
var player_die = false
var reset = false

func _process(delta):
	if move_mob >= quantity_mob:
		move_mob = 0
		#xod_player = true
		xod_player = true
	if quantity_mob <= 0:
		rand = randi_range(2, 5)
		spawn = true
		#print(rand)
	if quantity_mob >= rand:
		spawn = false
		#print(spawn)
	#print(quantity_mob)
	#print(player_xp)
#var player_pos
#@onready var tile_map = $"../TileMap"
#@onready var player = $"../player"
