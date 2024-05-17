extends Node2D

var cooldown = 20
var xod = false

func _process(_delta):
	if cooldown <= 0:
		queue_free()
	if cooldown == 2:
		$AnimationPlayer2.play("blink_slow")
	if cooldown == 1:
		$AnimationPlayer2.play("blink")
	if Global.xod_player == false && xod == false:
		cooldown -= 1
		#print(cooldown)
		xod = true
	if Global.xod_player == true && xod == true:
		xod = false

func _on_coin_area_entered(area):
	if area.name == "press":
		$AnimationPlayer2.stop()
		$AnimationPlayer2.play("colltction")
		Global.coin += 1 * Global.factor_coin
		await get_tree().create_timer(0.6).timeout
		queue_free()
	if area.name == "enviroment" || area.name == "block":
		queue_free()
