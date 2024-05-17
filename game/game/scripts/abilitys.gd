extends Node2D

@export var trap: PackedScene
@export var bomba: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("trap"):
		#$trap/AnimationPlayer.play("pressed")
		_trap()
	if Input.is_action_just_pressed("tnt"):
		#$tnt/AnimationPlayer.play("pressed")
		_bomba()

func _trap():
	if Global.coin >= 2 && Global.can_trap == true && Global.player_die == false:
		var temp_trap = trap.instantiate()
		$"../trap".add_child(temp_trap)
		temp_trap.global_position = Vector2($"../game/player".global_position.x, $"../game/player".global_position.y - 1)
		Global.coin -= 2

func _bomba():
	if Global.coin >= 5 && Global.player_die == false:
		var temp_bomba = bomba.instantiate()
		$"../game/player".add_child(temp_bomba)
		Global.coin -= 5
		#Global.player_xp -= 1

func _on_trap_pressed():
	#$trap/AnimationPlayer.play("pressed")
	_trap()
	$trap/trap.toggle_mode = false

func _on_bomba_pressed():
	#$tnt/AnimationPlayer.play("pressed")
	_bomba()
