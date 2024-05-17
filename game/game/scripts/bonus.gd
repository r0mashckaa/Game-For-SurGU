extends Node2D

@export var type: String
@export var shest = false
var cooldown = 6
var xod = false
var play = false
var end = false

func _ready():
	$bonuses/one_shot.visible = false
	await get_tree().create_timer(0.1).timeout
	if shest == true:
		#print(type)
		if type == "one_shot":
			$bonuses/one_shot.visible = true
		elif type == "factor_coin":
			$bonuses/factor_coin.visible = true
		elif type == "shild":
			$bonuses/shild.visible = true
		elif type == "more_coin":
			$bonuses/CoinBonus.visible = true
		elif type == "heart":
			$bonuses/BonusHeart.visible = true
		return
	var rand = randi_range(0,100)
	#print(rand)
	if rand <= 40:
		type = "one_shot"
		$bonuses/one_shot.visible = true
	elif rand <= 80:
		type = "factor_coin"
		$bonuses/factor_coin.visible = true
	elif rand > 80:
		type = "shild"
		$bonuses/shild.visible = true

func _process(_delta):
	if end == true:
		return
	if cooldown == 2:
		$blink.play("blink_slow")
	if cooldown == 1:
		$blink.play("blink")
	if cooldown <= 0:
		queue_free()
	if Global.xod_player == false && xod == false:
		cooldown -= 1
		#print(cooldown)
		xod = true
	if Global.xod_player == true && xod == true:
		xod = false

func _on_bonus_area_entered(area):
	if area.name == "press":
		$AnimationPlayer.stop()
		$blink.stop()
		end = true
		$blink.play("collection")
		if type == "one_shot":
			if Global.one_shot == false:
				Global.bonuses[Global.count_bonus] = "one_shot"
				Global.count_bonus += 1
			Global.one_shot = true
			Global.shot_count = 16
			Global._bonus()
		elif type == "factor_coin":
			if Global.factor_coin == 1:
				Global.bonuses[Global.count_bonus] = "factor_coin"
				Global.count_bonus += 1
			Global.factor_coin = 2
			Global.coin_count = 16
			Global._bonus()
		elif type == "shild":
			if Global.shild == false:
				Global.bonuses[Global.count_bonus] = "shild"
				Global.count_bonus += 1
			Global.shild = true
			Global.shild_count = 16
			Global._bonus()
		elif type == "heart":
			Global.player_xp += 1
		elif type == "more_coin":
			Global.coin += 4 * Global.factor_coin
		await get_tree().create_timer(0.6).timeout
		queue_free()
	if area.name == "enviroment" || area.name == "block":
		queue_free()

