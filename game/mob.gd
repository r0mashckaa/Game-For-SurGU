extends CharacterBody2D

@export var mob = "golem"
@export var xp_max = 1
var xp = xp_max
@onready var target = position
var speed = 200
var time = 0.2
var is_move = false
var rand
var veloc = 1
var direction = ""
var hit = false
var no_move = true
var xod_mob = false
var x: int = (randi_range(360, 792)/48) * 48 + 24
var y: int = (randi_range(110, 542)/48) * 48 + 14
var tm = 0

func _ready():
	if mob != "dummy":
		Global.quantity_mob += 1
		xod_mob = false
		Global.mob_move += 1
	if mob == "golem":
		$Dummy.visible = false
		$Golem.visible = true
	await get_tree().create_timer(time/2).timeout
	if mob == "dummy":
		if position.x > Global.player_pos_x:
			$Dummy.flip_h = true
		if position.x < Global.player_pos_x:
			$Dummy.flip_h = false

func _rotation():
	if veloc == 1:
		$Golem.flip_h = false
		$Golem.position.x = 0.5
	if veloc == -1:
		$Golem.flip_h = true
		$Golem.position.x = -0.5

func _stan():
	if xod_mob == true && hit == true && Global.xod_player == false:
		#await get_tree().create_timer(time).timeout
		#Global.xod_player = true
		xod_mob = false
		await get_tree().create_timer(time).timeout
		hit = false
		Global.mob_move += 1
		#print(hit)

func  _physics_process(_delta):
	if Global.xod_player == false && xod_mob == false:
		xod_mob = true
	#if Global.xod_player == false && hit == true:
	#if Global.xod_player == false && Global.xod_mob == true:
		#no_move = false
	_move()
	_rotation()
	_stan()
	#position = get_global_mouse_position()
	if xp <=0:
		if mob != "dummy":
			_die()
	if mob == "golem":
		_golem()
	if mob == "dummy":
		$Node2D/rigpush/CollisionShape2D.disabled = true
		$Node2D/lefpush/CollisionShape2D.disabled = true
		$Node2D/downpush/CollisionShape2D.disabled = true
		$Node2D/uppush/CollisionShape2D.disabled = true

func _push():
	if direction == "up":
		target -= Vector2(0, 48)
	elif direction == "down":
		target += Vector2(0, 48)
	if direction == "left":
		target -= Vector2(48, 0)
	elif direction == "right":
		target += Vector2(48, 0)

func _on_mob_area_entered(area):
	if area.name == "player" && Global.xod_player == true:
		xp -= Global.damage
	elif area.name == "player" && xod_mob == true && Global.xod_player == false:
		_push()
		Global.mob_move += 1
		xod_mob = false
		await get_tree().create_timer(time).timeout
		#Global.xod_player = true
		hit = true
		#print(hit)

func _die():
	Global.quantity_mob -= 1
	queue_free()

func _direction():
	#if Global.xod_player == false && is_move == false && hit == false: #&& no_move == false:
	if xod_mob == true && is_move == false && hit == false && Global.player_die == false: #&& no_move == false:
		is_move = true
		rand = randi_range(1, 2)
		if position.x < Global.player_pos_x - 16:
			target += Vector2(48, 0)
			veloc = 1
			direction = "left"
			#Global.mob_move += 1
		elif position.x > Global.player_pos_x + 16:
			target -= Vector2(48, 0)
			veloc = -1
			direction = "right"
			#Global.mob_move += 1
		else:
			if position.y < Global.player_pos_y:
				target += Vector2(0, 48)
				direction = "up"
				#Global.mob_move += 1
			elif position.y > Global.player_pos_y:
				target -= Vector2(0, 48)
				direction = "down"
				#Global.mob_move += 1
			else:
				rand = 1
		await get_tree().create_timer(time).timeout
		Global.mob_move += 1
		no_move = true
		is_move = false
		xod_mob = false
	elif Global.player_die == true:
		if xod_mob == true && is_move == false:
			#await get_tree().create_timer(1).timeout
			is_move = true
			#print(tm)
			if tm >=10:
				tm = 0
				x = (randi_range(408, 744)/48) * 48 + 24
				y = (randi_range(158, 494)/48) * 48 + 14
			if position.x < x - 16:
				target += Vector2(48, 0)
				veloc = 1
				direction = "left"
				#Global.mob_move += 1
				tm += 1
			elif position.x > x + 16:
				target -= Vector2(48, 0)
				veloc = -1
				direction = "right"
				#Global.mob_move += 1
				tm += 1
			else:
				if position.y < y:
					target += Vector2(0, 48)
					direction = "up"
					#Global.mob_move += 1
					tm += 1
				elif position.y > y:
					target -= Vector2(0, 48)
					direction = "down"
					#Global.mob_move += 1
					tm += 1
			await get_tree().create_timer(time).timeout
			is_move = false
			xod_mob = false

func _move():
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) >= 2:
		move_and_slide()

func _on_uppush_area_entered(area):
	if area.name == "push" || "wall":
		target += Vector2(0, 48)
	if area.name == "player" && Global.xod_player == true:
		xp -= Global.damage
	elif area.name == "player" && Global.xod_player == false:
		target += Vector2(0, 48)
		#Global.xod_player = true
		hit = true
		Global.mob_move += 1
		xod_mob = false

func _on_downpush_area_entered(area):
	if area.name == "push" || "wall":
		target -= Vector2(0, 48)
	if area.name == "player" && Global.xod_player == true:
		xp -= Global.damage
	elif area.name == "player" && Global.xod_player == false:
		target -= Vector2(0, 48)
		#Global.xod_player = true
		hit = true
		Global.mob_move += 1
		xod_mob = false

func _on_lefpush_area_entered(area):
	if area.name == "push" || "wall":
		target += Vector2(48, 0)
	if area.name == "player" && Global.xod_player == true:
		xp -= Global.damage
	elif area.name == "player" && Global.xod_player == false:
		target += Vector2(48, 0)
		#Global.xod_player = true
		hit = true
		Global.mob_move += 1
		xod_mob = false

func _on_rigpush_area_entered(area):
	if area.name == "push" || "wall":
		target -= Vector2(48, 0)
	if area.name == "player" && Global.xod_player == true:
		xp -= Global.damage
	elif area.name == "player" && Global.xod_player == false:
		target -= Vector2(48, 0)
		#Global.xod_player = true
		hit = true
		Global.mob_move += 1
		xod_mob = false

func _golem():
	_direction()
