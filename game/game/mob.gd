extends CharacterBody2D

@export var mob = "golem"
@export var xp_max = 1
var xp = xp_max
@onready var target = position
@onready var new_target = target
var old_target = target
var speed = 200
var time = 0.2
var is_move = false
var rand: int
var veloc = 1
var direction_push = ""
var direction_move = true
var hit = false
var no_move = true
var xod_mob = false
var x: int = (randi_range(360, 792)/48) * 48 + 24
var y: int = (randi_range(110, 542)/48) * 48 + 14
var timer_after_die = 0
var no_left = false
var no_right = false
var no_up = false
var no_down = false
var xod_label = false
var label

func _ready():
	if mob != "dummy":
		Global.quantity_mob += 1
		xod_mob = false
		Global.mob_move += 1
	if mob == "golem":
		$Platform/Dummy.visible = false
		$Platform/Golem.visible = true
	await get_tree().create_timer(time/4).timeout
	if mob == "dummy":
		if position.x > Global.player_pos_x:
			$Platform/Dummy.flip_h = true
		if position.x < Global.player_pos_x:
			$Platform/Dummy.flip_h = false

func _rotation():
	if veloc == 1:
		$Platform/Golem.flip_h = false
		$Platform/Golem.position.x = 0.5
	if veloc == -1:
		$Platform/Golem.flip_h = true
		$Platform/Golem.position.x = -0.5

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
	if Global.xod_player == false && xod_label == false:
		xod_label = true
	#if Global.xod_player == false && hit == true:
	#if Global.xod_player == false && Global.xod_mob == true:
		#no_move = false
	_move()
	_rotation()
	_stan()
	if xp <=0:
		if mob != "dummy":
			_die()
	if mob == "golem":
		_golem()
	if mob == "dummy":
		$push/rigpush/CollisionShape2D.disabled = true
		$push/lefpush/CollisionShape2D.disabled = true
		$push/downpush/CollisionShape2D.disabled = true
		$push/uppush/CollisionShape2D.disabled = true
		#$push/push/CollisionShape2D.disabled = true

func _push():
	if direction_push == "up":
		target -= Vector2(0, 48)
	elif direction_push == "down":
		target += Vector2(0, 48)
	if direction_push == "left":
		target -= Vector2(48, 0)
	elif direction_push == "right":
		target += Vector2(48, 0)
	#target = old_target

func _on_mob_area_entered(area):
	if area.name == "player" && Global.xod_player == true:
		xp -= Global.damage
	elif area.name == "player" && xod_mob == true && Global.xod_player == false:
		_push()
		Global.mob_move += 1
		xod_mob = false
		await get_tree().create_timer(time).timeout
		hit = true

func _die():
	Global.quantity_mob -= 1
	queue_free()

func _direct():
	if xod_label == true && is_move == false && hit == false && Global.player_die == false:
		old_target = target
		is_move = true
		#rand = randi_range(1, 2)
		#if position.x < Global.player_pos_x - 16:
			#new_target = target + Vector2(48, 0)
			#label = "right"
		#elif position.x > Global.player_pos_x + 16:
			#new_target = target + Vector2(-48, 0)
			#label = "left"
		#elif position.y < Global.player_pos_y:
			#new_target = target + Vector2(0, 48)
			#label = "down"
		#else:
			#new_target = target + Vector2(0, -48)
			#label = "up"
		new_target = target + Vector2(48, 0)
		label = "right"
		_move_label()
		await get_tree().create_timer(0.1).timeout
		new_target = target + Vector2(-48, 0)
		label = "left"
		_move_label()
		await get_tree().create_timer(0.1).timeout
		new_target = target + Vector2(0, 48)
		label = "down"
		_move_label()
		await get_tree().create_timer(0.1).timeout
		new_target = target + Vector2(0, -48)
		label = "up"
		_move_label()
		if direction_move == true:
			if position.x < Global.player_pos_x - 16 && no_right == false:
				new_target = target + Vector2(48, 0)
				veloc = 1
				direction_push = "left"
				_move_label()
				prints(target, new_target)
			elif  position.x > Global.player_pos_x + 16 && no_left == false:
				new_target = target + Vector2(-48, 0)
				veloc = -1
				direction_push = "right"
				_move_label()
				prints(target, new_target)
			elif position.y < Global.player_pos_y && no_down == false:
				new_target = target + Vector2(0, 48)
				direction_push = "up"
				direction_move = false
				prints(target, new_target)
				_move_label()
				direction_move = false
			elif position.y > Global.player_pos_y && no_up == false:
				new_target = target + Vector2(0, -48)
				direction_push = "down"
				direction_move = false
				prints(target, new_target)
				direction_move = false
				_move_label()
		else:
			if position.y < Global.player_pos_y - 16 && no_down == false:
				new_target = target + Vector2(0, 48)
				direction_push = "up"
				prints(target, new_target)
				_move_label()
			elif position.y > Global.player_pos_y + 16 && no_up == false:
				new_target = target + Vector2(0, -48)
				direction_push = "down"
				prints(target, new_target)
				_move_label()
			elif position.x < Global.player_pos_x && no_right == false:
				new_target = target + Vector2(48, 0)
				veloc = 1
				direction_push = "left"
				prints(target, new_target)
				direction_move = true
				_move_label()
			elif  position.x > Global.player_pos_x && no_left == false:
				new_target = target + Vector2(-48, 0)
				veloc = -1
				direction_push = "right"
				prints(target, new_target)
				direction_move = true
				_move_label()
		target = new_target
		#print(target)
		#print(new_target)
		#target = new_target
		await get_tree().create_timer(time).timeout
		Global.mob_move += 1
		no_move = true
		is_move = false
		xod_label = false
		Global.label_move += 1

func _move_label():
	$Label.global_position = new_target


func _direction():
	#if Global.xod_player == false && is_move == false && hit == false: #&& no_move == false:
	if xod_mob == true && is_move == false && hit == false && Global.player_die == false: #&& no_move == false:
		old_target = target
		is_move = true
		rand = randi_range(1, 2)
		if direction_move == true:
			if position.x < Global.player_pos_x - 16 && no_right == false:
				target += Vector2(48, 0)
				veloc = 1
				direction_push = "left"
			elif position.x > Global.player_pos_x + 16 && no_left == false:
				target -= Vector2(48, 0)
				veloc = -1
				direction_push = "right"
			else:
				if position.y < Global.player_pos_y && no_down == false:
					target += Vector2(0, 48)
					direction_push = "up"
					direction_move = false
				elif position.y > Global.player_pos_y && no_up == false:
					target -= Vector2(0, 48)
					direction_push = "down"
					direction_move = false
				else:
					if no_down == false:
						target += Vector2(0, 48)
						direction_push = "up"
					elif no_up == false:
						target -= Vector2(0, 48)
						direction_push = "down"
					#elif no_right == false:
					#	target += Vector2(48, 0)
					#	direction_push = "left"
					#	veloc = 1
					#elif no_left == false:
					#	target -= Vector2(48, 0)
					#	direction_push = "right"
					#	veloc = -1
		else:
			if position.y < Global.player_pos_y - 16 && no_down == false:
				target += Vector2(0, 48)
				direction_push = "up"
			elif position.y > Global.player_pos_y + 16 && no_up == false:
				target -= Vector2(0, 48)
				direction_push = "down"
			else:
				if position.x < Global.player_pos_x && no_right == false:
					target += Vector2(48, 0)
					veloc = 1
					direction_push = "left"
					direction_move = true
				elif position.x > Global.player_pos_x && no_left == false:
					target -= Vector2(48, 0)
					veloc = -1
					direction_push = "right"
					direction_move = true
				else:
					if no_right == false:
						target += Vector2(48, 0)
						veloc = 1
						direction_push = "left"
					elif no_left == false:
						target -= Vector2(48, 0)
						veloc = -1
						direction_push = "right"
					#elif no_down == false:
					#	target += Vector2(0, 48)
					#	direction_push = "up"
					#elif no_up == false:
					#	target -= Vector2(0, 48)
					#	direction_push = "down"
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
			if timer_after_die >=10:
				timer_after_die = 0
				x = (randi_range(408, 744)/48) * 48 + 24
				y = (randi_range(158, 494)/48) * 48 + 14
			if position.x < x - 16:
				target += Vector2(48, 0)
				veloc = 1
				timer_after_die += 1
			elif position.x > x + 16:
				target -= Vector2(48, 0)
				veloc = -1
				timer_after_die += 1
			else:
				if position.y < y:
					target += Vector2(0, 48)
					timer_after_die += 1
				elif position.y > y:
					target -= Vector2(0, 48)
					timer_after_die += 1
			await get_tree().create_timer(time).timeout
			is_move = false
			xod_mob = false

func _move():
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) >= 2:
		move_and_slide()
	else:
		$Label.global_position = target

func _on_uppush_area_entered(area):
	if area.name == "push" || "wall":
		target += Vector2(0, 48)
	if area.name == "player" && Global.xod_player == true:
		xp -= Global.damage
	elif area.name == "player" && Global.xod_player == false:
		target += Vector2(0, 48)
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
		hit = true
		Global.mob_move += 1
		xod_mob = false

#func _on_right_area_entered(area):
	if area.name == "push":
		if direction_move == true:
			no_right = true
			direction_move = false

#func _on_right_area_exited(area):
	if area.name == "push":
		no_right = false
		direction_move = false

#func _on_left_area_entered(area):
	if area.name == "push":
		if direction_move == true:
			no_left = true
			direction_move = false

#func _on_left_area_exited(area):
	if area.name == "push":
		no_left = false
		direction_move = false

#func _on_up_area_entered(area):
	if area.name == "push":
		if direction_move == false:
			no_up = true
			direction_move = true

#func _on_up_area_exited(area):
	if area.name == "push":
		no_up = false
		direction_move = true

#func _on_down_area_entered(area):
	if area.name == "push":
		if direction_move == false:
			no_down = true
			direction_move = true

#func _on_down_area_exited(area):
	if area.name == "push":
		no_down = false
		direction_move = true

func _golem():
	_direct()


func _on_label_area_entered(area):
	if area.name == "player" || "wall" || "label":
		if label == "up":
			no_up = true
		if label == "down":
			no_down = true
		if label == "left":
			no_left = true
		if label == "right":
			no_right = true
	#label = Vector2(new_target.x - target.x, new_target.y - target.y)
