extends Node2D

var xp_cout
var wave_cout

func _physics_process(_delta):
	pass
	xp_cout = Global.player_xp
	wave_cout = Global.wave
	$xp.text = "xp: " + str(xp_cout)
	$wave.text = "wave: " + str(wave_cout)
