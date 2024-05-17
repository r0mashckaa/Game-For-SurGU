extends Node2D

var count_bonus
@onready var start_pos = $".".global_position
var pos = start_pos
var bonus = false

func _ready():
	pass # Replace with function body.

func _bonus():
	if Global.bonuses[0] == "factor_coin":
		$bonus_1/factor_coin.visible = true
		$bonus_1/one_shot.visible = false
		$bonus_1/shild.visible = false
	elif Global.bonuses[0] == "one_shot":
		$bonus_1/factor_coin.visible = false
		$bonus_1/one_shot.visible = true
		$bonus_1/shild.visible = false
	elif Global.bonuses[0] == "shild":
		$bonus_1/factor_coin.visible = false
		$bonus_1/one_shot.visible = false
		$bonus_1/shild.visible = true
	else:
		$bonus_1/factor_coin.visible = false
		$bonus_1/one_shot.visible = false
		$bonus_1/shild.visible = false
	if Global.bonuses[1] == "factor_coin":
		$bonus_2/factor_coin.visible = true
		$bonus_2/one_shot.visible = false
		$bonus_2/shild.visible = false
	elif Global.bonuses[1] == "one_shot":
		$bonus_2/factor_coin.visible = false
		$bonus_2/one_shot.visible = true
		$bonus_2/shild.visible = false
	elif Global.bonuses[1] == "shild":
		$bonus_2/factor_coin.visible = false
		$bonus_2/one_shot.visible = false
		$bonus_2/shild.visible = true
	else:
		$bonus_2/factor_coin.visible = false
		$bonus_2/one_shot.visible = false
		$bonus_2/shild.visible = false
	if Global.bonuses[2] == "factor_coin":
		$bonus_3/factor_coin.visible = true
		$bonus_3/one_shot.visible = false
		$bonus_3/shild.visible = false
	elif Global.bonuses[2] == "one_shot":
		$bonus_3/factor_coin.visible = false
		$bonus_3/one_shot.visible = true
		$bonus_3/shild.visible = false
	elif Global.bonuses[2] == "shild":
		$bonus_3/factor_coin.visible = false
		$bonus_3/one_shot.visible = false
		$bonus_3/shild.visible = true
	else:
		$bonus_3/factor_coin.visible = false
		$bonus_3/one_shot.visible = false
		$bonus_3/shild.visible = false

func _blink():
	if Global.bonuses_counts[0] == 3:
		$AnimationPlayer.play("blink_slow")
	if Global.bonuses_counts[0] == 2:
		$AnimationPlayer.play("blink")
	if Global.bonuses_counts[1] == 3:
		$AnimationPlayer2.play("blink_slow")
	if Global.bonuses_counts[1] == 2:
		$AnimationPlayer2.play("blink")
	if Global.bonuses_counts[2] == 3:
		$AnimationPlayer3.play("blink_slow")
	if Global.bonuses_counts[2] == 2:
		$AnimationPlayer3.play("blink")

func _process(_delta):
	_bonus()
	_blink()
	if Global.xod_player == true && bonus == true:
		bonus = false
	if Global.count_bonus != 0:
		if Global.count_bonus % 2 == 1:
			pos = start_pos - Vector2(16 * (Global.count_bonus / 2), 0)
		else:
			pos = start_pos - Vector2(8 * (Global.count_bonus / 2), 0)
	else:
		pos = start_pos
	global_position = pos
