extends Node2D


func _on_coin_area_entered(area):
	if area.name == "press":
		Global.coin += 1
		queue_free()
	if area.name == "enviroment":
		queue_free()
