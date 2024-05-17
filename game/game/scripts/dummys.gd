extends Node2D

func _on_area_2d_area_entered(area):
	if area.name == "player":
		var rand = randi_range(1, 2)
		if rand == 1:
			$dummy_hit.play()
		elif rand == 2:
			$dymmy_hit1.play()
