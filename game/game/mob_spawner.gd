extends Node2D

@export var mob: PackedScene
var rand
var spawn = false
var x: int
var y: int
var wave = 0

func _ready():
	Global.wave = wave

func _physics_process(_delta):
	if Global.quantity_mob == 0:
		spawn = true
	if spawn == true:
		Global.xod_player = true
		spawn = false
		#await get_tree().create_timer(0.1).timeout
		#$Timer.start()
		#$Timer.timeout()
		_spawn()

func _spawn():
	#await get_tree().create_timer(1).timeout
	rand = randi_range(2, 5)
	for i in range(0, rand):
		var mobtemp = mob.instantiate()
		x = (randi_range(360, 792)/48) * 48 + 24
		while x < Global.player_pos_x + 48 * 3 && x > Global.player_pos_x - 48 * 3:
			x = (randi_range(360, 792)/48) * 48 + 24
		y = (randi_range(110, 542)/48) * 48 + 14
		while y > Global.player_pos_x + 48 * 3 && y < Global.player_pos_x - 48 * 3:
			y = (randi_range(110, 542)/48) * 48 + 14
		mobtemp.position = Vector2(x, y)
		add_child(mobtemp)
	wave += 1
	Global.wave = wave
	#print(wave)


func _on_timer_timeout():
	pass
