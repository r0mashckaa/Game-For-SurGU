extends CharacterBody2D

var speed = 600
@onready var start = position
@onready var target = start
var reset = Vector2(80, 68)

func _physics_process(_delta):
	if Xod.player_die == true:
		target = reset
	_move()

func _move():
	velocity = global_position.direction_to(target) * speed
	if global_position.distance_to(target) >= 10:
		move_and_slide()

func _on_resum_pressed():
	Xod.player_die = false
	Xod.xod_player = true
	Xod.move_mob = 0
	Xod.nomber_mob = 1
	Xod.wave = 0
	await get_tree().create_timer(0.5).timeout
	#get_tree().change_scene_to_file("res://game.tscn")
	get_tree().reload_current_scene()
	Xod.quantity_mob = 0

func _on_quit_pressed():
	get_tree().quit()
