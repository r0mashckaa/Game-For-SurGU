extends Node2D

@onready var anim_but_knight = $buttons/button_knight/AnimatedSprite2D

func _on_button_knight_area_entered(area):
	if area.name == "press":
		#print(1)
		Global.tutor_spawn = true
		anim_but_knight.play("on")


func _on_button_knight_area_exited(area):
	if area.name == "press":
		Global.tutor_spawn = false
		anim_but_knight.play("off")
