extends Node2D

func _ready():
	Global.place = "menu"

func _on_play_pressed():
	Global.place = "game"
	get_tree().change_scene_to_file("res://nodes/game.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_tutorial_pressed():
	Global.place = "tutorial"
	get_tree().change_scene_to_file("res://nodes/tutorial.tscn")
