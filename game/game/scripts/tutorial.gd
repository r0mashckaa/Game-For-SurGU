extends Node2D

@onready var anim_but_knight = $buttons/button_knight/button_knight
@onready var anim_but_golem = $buttons/button_golem/button_golem

func _ready():
	Global.place = "tutorial"

func _on_button_knight_area_entered(area):
	if area.name == "press":
		#print(1)
		Global.knight_spawn = true
		anim_but_knight.play("on")


func _on_button_knight_area_exited(area):
	if area.name == "press":
		Global.knight_spawn = false
		anim_but_knight.play("off")


func _on_button_golem_area_entered(area):
	if area.name == "press":
		Global.golem_spawn = true
		anim_but_golem.play("on")


func _on_button_golem_area_exited(area):
	if area.name == "press":
		Global.golem_spawn = false
		anim_but_golem.play("off")
