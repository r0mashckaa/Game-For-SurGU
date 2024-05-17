extends Node2D

@onready var player = $"../player"
@export var tile_max = Vector2i(10, 9)
var one = false

func _ready():
	Global.tile_max = tile_max
	if Global.place == "tutorial":
		return
	var x = randi_range(1, Global.tile_max.x) * 16 + 8
	var y = randi_range(1, Global.tile_max.y) * 16 + 8
	player.global_position = Vector2(x, y)
