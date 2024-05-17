extends Node2D

var xp_cout: int
var wave_cout: int
var coin_cout: int
# layer 1 - wall
# layer 2 - player
# layer 3 - mob
# layer 4 - area_on_push
# layer 5 - push
# layer 6 - area_on_move_mob
# layer 7 - label
# layer

func _ready():
	xp_cout = Global.player_xp
	wave_cout = Global.wave
	coin_cout = Global.coin

func _physics_process(_delta):
	if xp_cout < Global.player_xp:
		$state.play("xp+")
	elif xp_cout > Global.player_xp:
		$state.play("xp-")
	if wave_cout < Global.wave:
		$state.play("wave+")
		#$wave/wave2.play()
	if coin_cout < Global.coin:
		$state.play("coin+")
	elif coin_cout > Global.coin:
		$state.play("coin-")
	xp_cout = Global.player_xp
	wave_cout = Global.wave
	coin_cout = Global.coin
	$xp/xp.text = str(xp_cout)
	$wave/wave.text = str(wave_cout) #"wave: " + str(wave_cout)
	$coin/coin.text = str(coin_cout)
