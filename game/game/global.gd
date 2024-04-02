extends Node

var xod_player = false
var player_xp: int
var quantity_mob = 0
var nomber_mob = 1
var last_mob = 0
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
var coin = 0
var shop: bool
var spawner = false
var can_trap = true
var spawn_mob = 1

func _process(_delta):
	#print(place)
	#if quantity_mob == 0 && shop == true:
		#get_tree().change_scene_to_file("res://nodes/tutorial.tscn")
		#pass
	if nomber_call_mob > quantity_call_mob:
		call = false
	if move_mob >= quantity_mob:# && xod_player == false:
		move_mob = 0
		#xod_player = true
		await get_tree().create_timer(0.1).timeout
		xod_player = true
	if quantity_mob <= 0 && place == "game" && spawner == false:
		spawner = true
		xod_player = true
		var wave_min: int = wave/10
		var wave_max: int = wave/5
		#respawn = true
		#prints(wave_min, wave_max)
		#if set == false:
			#return
		#set = false
		await get_tree().create_timer(0.1).timeout
		#prints(range_min + wave_min, range_max + wave_max)
		rand = randi_range(range_min + wave_min, range_max + wave_max)
		#print(rand)
		spawn = true
		#wave += 1
		#print(spawn)
		#respawn = false
		#print(rand)
	#elif quantity_mob <= 0:
		#spawner = false
	if quantity_mob >= rand:
		#spawner = false
		spawn_mob = 1
		spawn = false
		#print(spawn)
	#print(quantity_mob)
	#print(player_xp)
	#if wave%3 == 0 && wave != 0 && shop == false && spawn == false:
		#shop = true
		#print(shop)
		#print(wave%10)
#var player_pos
#@onready var tile_map = $"../TileMap"
#@onready var player = $"../player"
