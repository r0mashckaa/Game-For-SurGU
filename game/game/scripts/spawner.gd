extends Node2D

@export var mob: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.nomber_mob <= Global.rand && Global.nomber_mob > Global.last_mob && Global.spawn == true && Global.spawn_mob == Global.nomber_mob:
		var temp_mob = mob.instantiate()
		$"../game".add_child(temp_mob)
		var pos
		if Global.nomber_mob <= 5:
			pos = (Vector2(-72 + (Global.nomber_mob - 1) * 16, 152))
		else:
			pos = (Vector2(200 + (Global.nomber_mob - 6) * 16, 152))
		temp_mob.global_position = pos
