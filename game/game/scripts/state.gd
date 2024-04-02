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

func _physics_process(_delta):
	xp_cout = Global.player_xp
	wave_cout = Global.wave
	coin_cout = Global.coin
	$Xpstatuia/xp.text = str(xp_cout)
	$Dummy/wave.text = str(wave_cout) #"wave: " + str(wave_cout)
	$Coin/coin.text = str(coin_cout)
