extends Node

var xod_player = true
var player_pos: Vector2
var player_pos_x: int
var player_pos_y: int
var quantity_mob = 0
var damage: int
var mob_move = 0
var player_die = false
var xod_mob = false
var player_xp: int
var wave: int
var label_move = 0
var tile_map
#var count_mob = 1

func _physics_process(_delta):
	#print(Global.quantity_mob)
	#prints(xod_player)
	if quantity_mob == 0:
		xod_player = true
	if label_move >= quantity_mob && player_die == false:
		#xod_player = false
		xod_mob == true
		label_move = 0
		#count_mob = 1
	if mob_move >= quantity_mob && player_die == false:
		xod_player = true
		xod_mob = false
		#await get_tree().create_timer(0.1).timeout
		mob_move = 0
	elif player_die == true:
		xod_player = false
		#xod_mob = false
	#else:
		#xod_mob = true
	#print(quantity_mob)
	#print(mob_move)
