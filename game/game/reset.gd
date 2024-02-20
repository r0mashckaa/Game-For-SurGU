extends CharacterBody2D

var speed = 600
@onready var start = position
@onready var target = start
var reset = Vector2(80, 68)

func _physics_process(_delta):
	if Global.player_die == true:
		target = reset
	_move()

func _move():
	velocity = global_position.direction_to(target) * speed
	if global_position.distance_to(target) >= 10:
		move_and_slide()

func _on_resum_pressed():
	Global.player_die = false
	Global.xod_player = true
	Global.move_mob = 0
	Global.nomber_mob = 1
	Global.wave = 0
	await get_tree().create_timer(0.5).timeout
	#get_tree().change_scene_to_file("res://game.tscn")
	get_tree().reload_current_scene()
	Global.quantity_mob = 0

func _on_quit_pressed():
	get_tree().quit()
