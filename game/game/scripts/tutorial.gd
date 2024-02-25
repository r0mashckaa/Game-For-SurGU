extends Node2D



func _on_button_area_entered(area):
	if area.name == "player":
		#print(1)
		Global.tutor_spawn = true


func _on_button_area_exited(area):
	if area.name == "player":
		Global.tutor_spawn = false
