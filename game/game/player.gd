extends CharacterBody2D

@export var speed = 200
var target_x = position.x
var target_y = position.y
@onready var target = position
@onready var start_target = position
var is_move = false
@export var cell = 1
var veloc = 1
var button = ""
@export var xp_max = 300
@onready var xp = xp_max
@export var damage = 1
var time = 0.2
var can_change_xod = true


func _ready():
	Global.player_pos_x = position.x
	Global.player_pos_y = position.y
	Global.player_xp = xp_max
	#print(xp_max)

func  _timer():
	await get_tree().create_timer(time * cell).timeout
	is_move = false
	start_target = target
	if can_change_xod == true:
		Global.xod_player = false
	else:
		can_change_xod = true

func  _rotation():
	if veloc == 1:
		$Player.flip_h = false
		$Player.position.x = 2
	if veloc == -1:
		$Player.flip_h = true
		$Player.position.x = -2

func get_input():
	if Global.xod_player == true:
		if is_move == false:
			if Input.is_action_just_pressed("left"):
				is_move = true
				button = "left"
				veloc= -1
				target -= Vector2(48 * cell, 0)
				_timer()
			if Input.is_action_just_pressed("ridht"):
				button = "right"
				is_move = true
				veloc = 1
				target += Vector2(48 * cell, 0)
				_timer()
			if Input.is_action_just_pressed("down"):
				button = "down"
				is_move = true
				target += Vector2(0, 48 * cell)
				_timer()
			if Input.is_action_just_pressed("up"):
				button = "up"
				is_move = true
				target -= Vector2(0, 48 * cell)
				_timer()

func  _physics_process(_delta):
	Global.player_pos = position
	Global.player_pos_x = position.x
	Global.player_pos_y = position.y
	Global.damage = damage
	#print(Global.quantity_mob)
	get_input()
	_move()
	_rotation()
	if xp <= 0:
		_die()

func _die():
	Global.player_die = true
	#await get_tree().create_timer(time).timeout
	#print(Global.player_die)
	queue_free()

func _move():
	velocity = global_position.direction_to(target) * speed
	if global_position.distance_to(target) >= 2:
		move_and_slide()

func _on_player_area_entered(area):
	if Global.xod_player == false && area.name == "mob":
		xp -= 1
		Global.player_xp = xp
		#print(xp)
	if Global.xod_player == true && area.name == "mob" && is_move == true:
		target = start_target
	if Global.xod_player == true && area.name == "wall":
		can_change_xod = false
		target = start_target


