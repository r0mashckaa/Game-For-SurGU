extends Node2D

var xp_die = 0
var vid
var nomber

func _ready():
	nomber = Global.nomber_enviroment
	Global.nomber_enviroment += 1
	print(nomber)
	xp_die = 2

func _process(_delta):
	if Global.enviroment_spawn == false:
		return
	
	for i in range(Global.enviroment.size()):
		if i != nomber:
			continue
		if Global.enviroment[i] == "vase":
			vid = "vase"
			$Vase.visible = true
			$Column.visible = false
		elif  Global.enviroment[i] == "column":
			vid = "column"
			$Column.visible = true
			$Vase.visible = false

func _physics_process(_delta):
	if xp_die <= 0:
		if vid == "vase":
			queue_free()

func _on_enviroment_area_entered(area):
	if area.name == "player":
		xp_die -= 1
		print(xp_die)
