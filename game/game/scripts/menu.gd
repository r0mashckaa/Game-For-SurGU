extends Node2D

func _ready():
	Global.place = "menu"

func _on_play_pressed():
	Global.place = "game"
	$AudioStreamPlayer2.play()
	#$Node2D/AnimationPlayer.play("clouse")
	#await get_tree().create_timer(1).timeout
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://nodes/game.tscn")

func _on_quit_pressed():
	$AudioStreamPlayer2.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func _on_tutorial_pressed():
	Global.place = "tutorial"
	$AudioStreamPlayer2.play()
	#$Node2D/AnimationPlayer.play("clouse")
	#await get_tree().create_timer(1).timeout
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://nodes/tutorial.tscn")

func _on_play_mouse_entered():
	#$play/ButtonPlay.scale = Vector2(7, 7)
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("play_down")

func _on_play_mouse_exited():
	#$play/ButtonPlay.scale = Vector2(8, 8)
	$AnimationPlayer.play("play_up")

func _on_quit_mouse_entered():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("quit_down")

func _on_quit_mouse_exited():
	$AnimationPlayer.play("quit_up")

func _on_tutorial_mouse_entered():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("tutorial_down")

func _on_tutorial_mouse_exited():
	$AnimationPlayer.play("tutorial_up")
