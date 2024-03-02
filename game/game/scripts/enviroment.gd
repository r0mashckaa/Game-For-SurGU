extends Node2D

var xp_die = 0
var vid
var nomber
@export var thorns: PackedScene
var stan = true
var move
@onready var cooldown = randi_range(2,  3)

func _ready():
	var rand = randi_range(0, 100)
	if rand <= 30:
	#	Global.enviroment[i] = 2 #"vase"
		vid  = "column"
	elif  rand <= 80:
	#	Global.enviroment[i] = 1 #"column"
		vid = "vase"
	elif rand > 80:
		vid = "spikes"
	if vid == "vase":
		$decors/Vase.visible = true
		#$Column.visible = false
	elif  vid == "column":
		$decors/Column.visible = true
		#$Vase.visible = false
	elif vid == "spikes":
		#var temp_thorns = thorns.instantiate()
		#get_tree().root.
		#add_child(temp_thorns)
		#temp_thorns.global_position = global_position#Global.marker_pos
		$decors.queue_free()
		$spikes/spike.visible = true

func _process(_delta):
	if Global.reset_player == true:
		stan = true
		return
	if Global.xod_player == true:
		move = false
		return
	if move == true:
		return
	if vid == "spikes":
		_spikes()

func _physics_process(_delta):
	if xp_die >= 1:
		if vid == "vase":
			queue_free()

func _spikes():
	if stan == true:
		cooldown -= 1
		#await get_tree().create_timer(1).timeout
		move = true
		if cooldown == 1:
			$spikes/spike.play("ready")
		if cooldown > 0:
			return
		$spikes/spike.play("on")
		$spikes/spikes/CollisionShape2D.disabled = false
		stan = false
		return
	$spikes/spike.play("off")
	$spikes/spikes/CollisionShape2D.disabled = true
	stan = true
	cooldown = 3

func _on_enviroment_area_entered(area):
	if area.name == "player":
		xp_die += 1
		#print(xp_die)
