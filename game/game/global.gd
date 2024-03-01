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
var range_min = 2
var range_max = 3
var nomber_call_mob = 1
var quantity_call_mob = 1
var call: bool
var call_tile
var reset_player: bool
var place = "menu"
var knight_spawn = false
var golem_spawn = false
var set = true
var respawn
var label = false

func _process(_delta):
	#print(place)
	if nomber_call_mob > quantity_call_mob:
		call = false
	if move_mob >= quantity_mob:
		move_mob = 0
		#xod_player = true
		xod_player = true
	if quantity_mob <= 0 && place == "game":
		var wave_min: int = wave/10
		var wave_max: int = wave/5
		#respawn = true
		#prints(wave_min, wave_max)
		#if set == false:
			#return
		#set = false
		#await get_tree().create_timer(0.1).timeout
		#prints(range_min + wave_min, range_max + wave_max)
		rand = randi_range(range_min + wave_min, range_max + wave_max)
		spawn = true
		#respawn = false
		#print(rand)
	if quantity_mob >= rand:
		spawn = false
		#print(spawn)
	#print(quantity_mob)
	#print(player_xp)
#var player_pos
#@onready var tile_map = $"../TileMap"
#@onready var player = $"../player"
