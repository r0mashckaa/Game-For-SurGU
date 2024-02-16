extends Node

var xod_player = true
var player_pos
var player_pos_x
var player_pos_y
var quantity_mob = 0
var damage
var mob_move = 0
var player_die = false
var xod_mob = false
var player_xp
var wave

func _physics_process(_delta):
	#print(Global.quantity_mob)
	#prints(xod_player)
	if quantity_mob == 0:
		xod_player = true
	if mob_move >= quantity_mob && player_die == false:
		xod_player = true
		#await get_tree().create_timer(0.1).timeout
		mob_move = 0
	elif player_die == true:
		xod_player = false
		#xod_mob = false
	#else:
		#xod_mob = true
	#print(quantity_mob)
	#print(mob_move)
