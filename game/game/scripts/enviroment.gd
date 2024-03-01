extends Node2D

var xp_die = 0
var vid
var nomber

func _ready():
	var rand = randi_range(0, 100)
	if rand <= 30:
	#	Global.enviroment[i] = 2 #"vase"
		vid  = "column"
	elif  rand <= 80:
	#	Global.enviroment[i] = 1 #"column"
		vid = "vase"
	elif rand > 80:
		vid = "thorns"
	if vid == "vase":
		$Vase.visible = true
		#$Column.visible = false
	elif  vid == "column":
		$Column.visible = true
		#$Vase.visible = false
	elif vid == "thorns":
		$thorns.visible = true
		$enviroment/CollisionShape2D.disabled = true
		

func _physics_process(_delta):
	if xp_die >= 1:
		if vid == "vase":
			queue_free()

func _on_enviroment_area_entered(area):
	if area.name == "player":
		xp_die += 1
		#print(xp_die)
