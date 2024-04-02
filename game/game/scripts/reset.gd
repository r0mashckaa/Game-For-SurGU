extends CharacterBody2D

var speed = 600
@onready var start = position
@onready var target = start
var reset = Vector2(position.x, position.y + 184)
#var set = false

func _physics_process(_delta):
	if Global.player_die == true:
		target = reset
	if Input.is_action_just_pressed("menu") && Global.reset == false && Global.player_die == false:
		target = reset
		Global.reset = true
	elif Input.is_action_just_pressed("menu") && Global.reset == true && Global.player_die == false:
		target = start
		Global.reset = false
	_move()

func _move():
	velocity = global_position.direction_to(target) * speed
	if global_position.distance_to(target) >= 10:
		move_and_slide()

func _on_resum_pressed():
	_update()
	get_tree().reload_current_scene()
	Global.reset_player = false
	Global.quantity_call_mob = 1
	Global.quantity_mob = 0

func _on_quit_pressed():
	get_tree().quit()

func _update():
	Global.player_die = false
	Global.reset = false
	Global.xod_player = false
	Global.player_xp = 3
	Global.move_mob = 0
	Global.nomber_mob = 1
	Global.wave = 0
	Global.coin = 0
	Global.last_mob = 0
	Global.spawner = false
	#Global.label = true
	Global.nomber_call_mob = 1
	Global.reset_player = true
	Global.rand = 0
	Global.shop = false
	#Global.enviroment = []
	await get_tree().create_timer(0.5).timeout
	#get_tree().change_scene_to_file("res://game.tscn")
	

func _on_menu_pressed():
	_update()
	Global.reset_player = false
	Global.quantity_call_mob = 1
	Global.quantity_mob = 0
	get_tree().change_scene_to_file("res://nodes/menu.tscn")
	
