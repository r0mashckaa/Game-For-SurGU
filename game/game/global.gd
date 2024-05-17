extends Node

#player
var xod_player = false
var player_xp: int
var player_die = false
var reset_player: bool
var move = false
#mob
var quantity_mob = 0
var quantity_armor = 0
var nomber_mob = 1
var last_mob = 0
var move_mob = 0
var nomber_call_mob = 1
var quantity_call_mob = 1
var spawn_mob = 1
var spawner = false
var spawn = false
var call: bool
var call_tile
var hit = false
#state
var rand: int
var wave = 0
var coin = 0
var range_min = 2
var range_max = 3
#bonus
var bonuses: Array = ["", "", ""]
var bonuses_counts: Array = [0, 0, 0]
var max_bonus = 3
var one_shot = false
var factor_coin = 1
var bonus = false
var shot_count = 0
var coin_count = 0
var shild_count = 0
var shild = false
var count_bonus = 0
#more
var tile_max: Vector2i
var bomba = false
var reset = false
var place = "menu"
var set = true
var respawn
var label = false
var shop: bool
var can_trap = true
var shest = false

func _bonus():
	for i in range(0, 3):
		#print(i)
		if bonuses[i] == "factor_coin":
			bonuses_counts[i] = coin_count
		if bonuses[i] == "one_shot":
			bonuses_counts[i] = shot_count
		if bonuses[i] == "shild":
			bonuses_counts[i] = shild_count

func _process(_delta):
	if bonuses[0] == "":
		#print(1)
		bonuses[0] = bonuses[1]
		bonuses[1] = ""
	if bonuses[1] == "":
		#print(2)
		bonuses[1] = bonuses[2]
		bonuses[2] = ""
	#prints(quantity_mob, nomber_mob, last_mob, spawn_mob, quantity_armor)
	if count_bonus > max_bonus:
		count_bonus = max_bonus
	if xod_player == false && bonus == false:
		_bonus()
		if one_shot == true && shot_count > 1:
			shot_count -= 1
		elif shot_count == 1:
			shot_count -= 1
			var ind = 0
			for i in bonuses:
				if i == "one_shot":
					bonuses[ind] = ""
				ind += 1
			#one_shot = false
			count_bonus -= 1
		else:
			shot_count = 0
			one_shot = false
		if factor_coin != 1 && coin_count > 1:
			coin_count -= 1
		elif coin_count == 1:
			coin_count -= 1
			#factor_coin = 1
			var ind = 0
			for i in bonuses:
				if i == "factor_coin":
					bonuses[ind] = ""
				ind += 1
			count_bonus -= 1
		else:
			coin_count = 0
			factor_coin = 1
		if shild == true && shild_count > 1:
			shild_count -= 1
		elif shild_count == 1:
			shild_count -= 1
			#shild = false
			var ind = 0
			for i in bonuses:
				if i == "shild":
					bonuses[ind] = ""
				ind += 1
			count_bonus -= 1
		else:
			shild_count = 0
			shild = false
		bonus = true
		#print(count_bonus)
	#prints(shot_count, coin_count, shild_count)
	#prints(bonuses, bonuses_counts)
	if xod_player == true && bonus == true:
		bonus = false
	#print(place)
	#if quantity_mob == 0 && shop == true:
		#get_tree().change_scene_to_file("res://nodes/tutorial.tscn")
		#pass
	if nomber_call_mob > quantity_call_mob:
		call = false
	#prints(move_mob, quantity_mob)
	if move_mob >= quantity_mob:# && xod_player == false:
		move_mob = 0
		#xod_player = true
		#await get_tree().create_timer(0.1).timeout
		move = false
		if quantity_mob == 0:
			await get_tree().create_timer(0.3).timeout
			xod_player = true
		xod_player = true
	if xod_player == true:
		move_mob = 0
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
