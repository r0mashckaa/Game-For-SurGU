extends Node2D

@export var trap: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("trap"):
		_trap()
	if Input.is_action_just_pressed("tnt"):
		_tnt()

func _trap():
	if Global.coin >= int($trap/Label.text) && Global.can_trap == true && Global.player_die == false:
		var temp_trap = trap.instantiate()
		$"../Node2D".add_child(temp_trap)
		temp_trap.global_position = Vector2($"../game/player".global_position.x, $"../game/player".global_position.y - 1)
		Global.coin -= int($trap/Label.text)

func _tnt():
	pass

func _on_trap_pressed():
	_trap()
