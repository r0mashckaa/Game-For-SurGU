extends Node2D

@export var bonus = ""

func _process(_delta):
	if bonus == "one_shot":
		$one_shot.visible = true
	if bonus == "factor_coin":
		$factor_coin.visible = true
	if bonus == "shild":
		$shild.visible = true
