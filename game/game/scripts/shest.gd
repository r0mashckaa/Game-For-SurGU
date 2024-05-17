extends Node2D

var is_spawn = true
@onready var sprite = $AnimatedSprite2D
@export var bonus: PackedScene
var old_rand
var rand
var shest = false
var end = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Shest.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if is_spawn == true:
		sprite.global_position = sprite.global_position.move_toward($Shest.global_position, 2)
		if sprite.global_position != global_position:
			return
		is_spawn = false
	if end == true:
		sprite.global_position = sprite.global_position.move_toward(global_position, 2)
		if sprite.global_position != global_position:
			return
		Global.shest = false
		queue_free()

func _change_bonus():
	$"../../../music".volume_db = -30
	$music.play(18.5)
	var long = 1
	for i in range(0,55):
		rand = randi_range(1, 5)
		#print(rand)
		if i != 55:
			$bonus.pitch_scale = randf_range(0.80, 1.20)
		else:
			$bonus.pitch_scale = 0.8
		_icon_on()
		if i > 40:
			long += 0.1
		await get_tree().create_timer(0.15 * long).timeout
		time += 0.15 * long
		#print(time)
		#await get_tree().create_timer(0.1).timeout
		_icon_off()
	_icon_on()
	$AnimationPlayer.play("icon_down")
	await get_tree().create_timer(0.8).timeout
	var temp_bonus = bonus.instantiate()
	$"..".add_child(temp_bonus)
	temp_bonus.shest = true
	if rand == 1:
		temp_bonus.type = "more_coin"
	elif rand == 2:
		temp_bonus.type = "factor_coin"
	elif rand == 3:
		temp_bonus.type = "one_shot"
	elif rand == 4:
		temp_bonus.type = "shild"
	elif rand == 5:
		temp_bonus.type = "heart"
	temp_bonus.global_position = global_position
	_icon_off()
	$AnimatedSprite2D.play("default")
	var pos = global_position
	global_position += Vector2(0, -180)
	sprite.global_position = pos
	$decor.queue_free()
	end = true
	$"../../../music".volume_db = -15

func _icon_off():
	if rand == 1:
		$icon/CoinBonus.visible = false
	elif rand == 2:
		$icon/coin.visible = false
	elif rand == 3:
		$icon/shot.visible = false
	elif rand == 4:
		$icon/shild.visible = false
	elif rand == 5:
		$icon/BonusHeart.visible = false

func _icon_on():
	#if old_rand != rand:
	$bonus.play()
	#old_rand = rand
	if rand == 1:
		$icon/CoinBonus.visible = true
	elif rand == 2:
		$icon/coin.visible = true
	elif rand == 3:
		$icon/shot.visible = true
	elif rand == 4:
		$icon/shild.visible = true
	elif rand == 5:
		$icon/BonusHeart.visible = true

func _on_shest_area_entered(area):
	if area.name == "player" && shest == false:
		$shest2.play()
		await get_tree().create_timer(0.1).timeout
		shest = true
		$AnimationPlayer.play("icon_up")
		$AnimatedSprite2D.play("open")
		_change_bonus()
